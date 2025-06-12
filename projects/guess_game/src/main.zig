const std = @import("std");

const stdout = std.debug;
const stdin = std.io.getStdIn().reader();

var ans: u32 = undefined;

fn read_u8() anyerror!u8 {
    var result: u8 = undefined;
    var line_buf: [256]u8 = undefined;

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

fn guessed(n: u32) bool {
    if (n == ans) {
        stdout.print("Correct! Congratulations!\n", .{});
        return true;
    }

    if (n < ans)
        stdout.print("Too low!\n", .{})
    else
        stdout.print("Too high!\n", .{});

    return false;
}

pub fn main() void {
    const rand = std.crypto.random;
    var min_num: u8 = undefined;
    var max_num: u8 = undefined;

    stdout.print("Welcome to the Guess Game!\n", .{});
    stdout.print("Firstly you need to enter a range (e.g. from 1 to 100)\n", .{});

    while (true) {
        while (true) {
            stdout.print("Enter minimal number: ", .{});
            min_num = read_u8() catch continue;
            break;
        }

        while (true) {
            stdout.print("Enter maximal number: ", .{});
            max_num = read_u8() catch continue;
            break;
        }

        if (min_num >= max_num) {
            stdout.print("Minimal number must be less than maximal!\n", .{});
            continue;
        }

        break;
    }

    ans = (rand.int(u8) + min_num) % max_num;

    stdout.print("Start guessing!\n", .{});
    while (true) {
        stdout.print("> ", .{});
        const choice = read_u8() catch continue;

        if (guessed(choice)) break;
    }
}
