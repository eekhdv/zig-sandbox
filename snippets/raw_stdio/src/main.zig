const std = @import("std");
const fs = std.fs;

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
    @cInclude("stdlib.h");
});

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var termios: c.termios = undefined;

    var tty = try fs.openFileAbsolute("/dev/tty", .{ .mode = .read_write });
    defer tty.close();

    _ = c.tcgetattr(tty.handle, &termios);

    try stdout.print("fd:{};speed:{};iflag:{}\n", .{ tty.handle, termios.c_ospeed, termios.c_iflag });
    try bw.flush();
}

const lib = @import("raw_stdio_lib");
