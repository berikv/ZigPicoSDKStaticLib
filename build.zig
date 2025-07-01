const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const my_module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const my_module_lib = b.addLibrary(.{
        .name = "my_module",
        .root_module = my_module,
        .linkage = .static,
    });

    b.installArtifact(my_module_lib);
}
