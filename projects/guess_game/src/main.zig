const std = @import("std");
const stdin = std.io.getStdIn().reader();

const MAX_GAME_NUMBER: u32 = 100000;
const ans: u32 = 9;

fn guessed(n: u32) bool {
    if (n == ans) {
        std.debug.print("Congratulations!\n", .{});
        return true;
    }
    std.debug.print("Wrong answer :( Try again.\n", .{});
    return false;
}

pub fn main() void {
    var choice: u32 = undefined;
    var line_buf: [100]u8 = undefined;

    std.debug.print("Welcome to the Guess Game!\nEnter number from 0 to {}\n", .{MAX_GAME_NUMBER});
    while (true) {
        line_buf = undefined;
        choice = undefined;

        std.debug.print("> ", .{});
        const len = stdin.read(&line_buf) catch |err| {
            std.debug.print("Error while reading from stdin. Try again. {}\n", .{err});
            continue;
        };

        const line = std.mem.trimRight(u8, line_buf[0..len], "\r\n");

        choice = std.fmt.parseUnsigned(u32, line, 10) catch {
            std.debug.print("Invalid number.\n", .{});
            continue;
        };

        if (choice > MAX_GAME_NUMBER) {
            std.debug.print("Invalid number.\n", .{});
            continue;
        }

        if (guessed(choice)) {
            break;
        }
    }
}
