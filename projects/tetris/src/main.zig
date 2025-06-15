const std = @import("std");
const fs = std.fs;
const mem = std.mem;

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
    @cInclude("stdlib.h");
});

const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
const stdout = bw.writer();
const stderr = std.debug;

const Direction = enum { up, down, left, right };

fn input(tty: *fs.File, termios: *c.termios) !Direction {
    var esc_buffer: [8]u8 = undefined;
    const esc_read = try tty.read(&esc_buffer);

    termios.*.c_cc[c.VTIME] = 0;
    termios.*.c_cc[c.VMIN] = 1;
    _ = c.tcsetattr(tty.handle, c.TCSANOW, termios);
    stderr.print("input: ", .{});
    if (mem.eql(u8, esc_buffer[0..esc_read], "[A")) {
        return .up;
    } else if (mem.eql(u8, esc_buffer[0..esc_read], "[B")) {
        return .down;
    } else if (mem.eql(u8, esc_buffer[0..esc_read], "[C")) {
        return .right;
    } else if (mem.eql(u8, esc_buffer[0..esc_read], "[D")) {
        return .left;
    }
    return error.UnknownEscapeKey;
}

fn update() !void {
    return;
}

fn render() !void {
    return;
}

pub fn main() !void {
    var tty = try fs.openFileAbsolute("/dev/tty", .{ .mode = .read_write });
    defer tty.close();

    var orig_termios: c.termios = undefined;
    _ = c.tcgetattr(tty.handle, &orig_termios);
    defer _ = c.tcsetattr(tty.handle, c.TCSAFLUSH, &orig_termios);

    var cur_termios = orig_termios;

    while (true) {
        _ = input(&tty, &cur_termios) catch {
            // TODO:
            asm volatile ("nop");
        };
        try update(); // TODO:
        try render(); // TODO:
    }
    // try bw.flush(); // Don't forget to flush!
}
