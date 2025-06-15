const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize: std.builtin.OptimizeMode = .ReleaseFast;

    // Projects
    const guess_game = b.addExecutable(.{
        .name = "guess_game",
        .root_source_file = b.path("projects/guess_game/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(guess_game);

    const tetris = b.addExecutable(.{
        .name = "tetris",
        .root_source_file = b.path("projects/tetris/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(tetris);

    // Snippets
    const raw_stdio = b.addExecutable(.{
        .name = "raw_stdio",
        .root_source_file = b.path("snippets/raw_stdio/src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(raw_stdio);

    const default_step = b.step("default", "Собрать все артефакты по умолчанию");
    default_step.dependOn(b.getInstallStep());
}
