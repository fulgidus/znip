const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("zig-app/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    exe.linkSystemLibrary("X11");
    b.installArtifact(exe);
}
