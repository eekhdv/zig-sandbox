const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // .Debug, .ReleaseSafe, .ReleaseSmall, .ReleaseFast
    const optimize = b.standardOptimizeOption(.{});

    const guess_game = b.addExecutable(.{
        .name = "guess_game",
        .root_source_file = b.path("projects/guess_game/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(guess_game);

    const run_guess_game = b.addRunArtifact(guess_game);
    run_guess_game.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_guess_game.addArgs(args);
    }

    const run_my_cli_app_step = b.step("run-my-cli-app", "Запустить проект guess_game");
    run_my_cli_app_step.dependOn(&run_guess_game.step);


    //const quick_test_exe = b.addExecutable(.{
    //    .name = "quick_test_snippet",
    //    .root_source_file = .{ .path = "snippets/quick_test.zig" },
    //    .target = target,
    //    .optimize = optimize,
    //});

    //b.installArtifact(quick_test_exe);

    //const run_quick_test_cmd = b.addRunArtifact(quick_test_exe);
    //run_quick_test_cmd.step.dependOn(b.getInstallStep());
    //if (b.args) |args| {
    //    run_quick_test_cmd.addArgs(args);
    //}
    //const run_quick_test_step = b.step("run-quick-test", "Запустить сниппет quick_test.zig");
    //run_quick_test_step.dependOn(&run_quick_test_cmd.step);


    const default_step = b.step("default", "Собрать все артефакты по умолчанию");
    default_step.dependOn(b.getInstallStep());
}

