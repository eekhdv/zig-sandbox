const std = @import("std");

const stdout = std.debug;
const stdin = std.io.getStdIn().reader();

const MAX_GAME_NUMBER: u32 = 256;
var ans: u32 = undefined;

fn read_u8() anyerror!u8 {
    var result: u8 = undefined;
    var line_buf: [5]u8 = undefined;

    const len = stdin.read(&line_buf) catch |err| {
        stdout.print("Error while reading from stdin. Try again. {}\n", .{err});
        return err;
    };

    const line = std.mem.trimRight(u8, line_buf[0..len], "\r\n");

    result = std.fmt.parseUnsigned(u8, line, 10) catch |err| {
        stdout.print("Invalid number.\n", .{});
        return err;
    };

    return result;
}

fn read_range() anyerror!std.meta.Tuple(&.{ u8, u8 }) {
    stdout.print("Firstly you need to enter a range (e.g. from 1 to 100)\n", .{});
    stdout.print("Enter minimal number: ", .{});
    const min_num = read_u8() catch |err| {
        return err;
    };

    stdout.print("Enter maximal number: ", .{});
    const max_num = read_u8() catch |err| {
        return err;
    };

    if (min_num >= max_num) {
        return error.MinBiggerMax;
    }
    return .{ @as(u8, min_num), @as(u8, max_num) };
}

fn guessed(n: u32) bool {
    if (n == ans) {
        stdout.print("Correct! Congratulations!\n", .{});
        return true;
    }

    if (n < ans) {
        stdout.print("Too low!\n", .{});
    } else {
        stdout.print("Too high!\n", .{});
    }
    return false;
}

pub fn main() void {
    const rand = std.crypto.random;

    stdout.print("Welcome to the Guess Game!\n", .{});
    const range = read_range() catch |err| {
        switch (err) {
            error.MinBiggerMax => {
                stdout.print("Minimal number cannot be bigger than maximal!", .{});
            },
            else => {
                stdout.print("Error while reading range!", .{});
            },
        }
        std.process.exit(1);
    };

    const min_num = range[0];
    const max_num = range[1];

    ans = (rand.int(u8) + min_num) % max_num;

    while (true) {
        stdout.print("> ", .{});
        const choice = read_u8() catch {
            stdout.print("Invalid number!", .{});
            continue;
        };

        if (guessed(choice)) {
            break;
        }
    }
}
