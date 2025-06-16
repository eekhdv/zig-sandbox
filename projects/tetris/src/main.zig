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

const Direction = enum { up, down, left, right, exit };

fn input(tty: *fs.File, termios: *c.termios) !Direction {
    var buffer: [1]u8 = undefined;
    _ = try tty.read(&buffer);

    if (buffer[0] == 'q') {
        return .exit;
    }
    termios.*.c_cc[c.VTIME] = 1;
    termios.*.c_cc[c.VMIN] = 0;
    _ = c.tcsetattr(tty.handle, c.TCSANOW, termios);

    var esc_buffer: [8]u8 = undefined;
    const esc_read = try tty.read(&esc_buffer);

    termios.*.c_cc[c.VTIME] = 0;
    termios.*.c_cc[c.VMIN] = 1;
    _ = c.tcsetattr(tty.handle, c.TCSANOW, termios);
    if (esc_read == 2) {
        switch (esc_buffer[1]) {
            'A' => {
                stderr.print("arrow up\r\n", .{});
                return .up;
            },
            'B' => {
                stderr.print("arrow down\r\n", .{});
                return .down;
            },
            'C' => {
                stderr.print("arrow right\r\n", .{});
                return .right;
            },
            'D' => {
                stderr.print("arrow left\r\n", .{});
                return .left;
            },
            else => return error.UnknownEscapeKey,
        }
    }
    unreachable;
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

    // Setup line flags
    cur_termios.c_lflag &= ~@as(
        c.tcflag_t,
        //   ECHO: Stop the terminal from displaying pressed keys.
        // ICANON: Disable canonical ("cooked") input mode. Allows us to read inputs
        //         byte-wise instead of line-wise.
        //   ISIG: Disable signals for Ctrl-C (SIGINT) and Ctrl-Z (SIGTSTP), so we
        //         can handle them as "normal" escape sequences.
        // IEXTEN: Disable input preprocessing. This allows us to handle Ctrl-V,
        //         which would otherwise be intercepted by some terminals.
        c.ECHO | c.ICANON | c.ISIG | c.IEXTEN,
    );

    // Setup input flags
    cur_termios.c_iflag &= ~@as(
        c.tcflag_t,
        //   IXON: Disable software control flow. This allows us to handle Ctrl-S
        //         and Ctrl-Q.
        //  ICRNL: Disable converting carriage returns to newlines. Allows us to
        //         handle Ctrl-J and Ctrl-M.
        // BRKINT: Disable converting sending SIGINT on break conditions. Likely has
        //         no effect on anything remotely modern.
        //  INPCK: Disable parity checking. Likely has no effect on anything
        //         remotely modern.
        // ISTRIP: Disable stripping the 8th bit of characters. Likely has no effect
        //         on anything remotely modern.
        c.IXON | c.ICRNL | c.BRKINT | c.INPCK | c.ISTRIP,
    );

    // Setup output flags
    // OPOST: Disable output processing. Common output processing includes prefixing
    //        newline with a carriage return.
    cur_termios.c_oflag &= ~@as(c.tcflag_t, c.OPOST);

    // Setup control flags
    // CS8: Set the character size to 8 bits per byte. Likely has no efffect on
    //      anything remotely modern.
    cur_termios.c_cflag |= c.CS8;

    cur_termios.c_cc[c.VTIME] = 0;
    cur_termios.c_cc[c.VMIN] = 1;

    _ = c.tcsetattr(tty.handle, c.TCSAFLUSH, &cur_termios);

    main_loop: while (true) {
        const key = input(&tty, &cur_termios) catch {
            continue;
        }; // TODO: catch {}
        switch (key) {
            .exit => {
                break :main_loop;
            },
            else => {
                continue;
            },
        }
        try update(); // TODO:
        try render(); // TODO:
    }
}
