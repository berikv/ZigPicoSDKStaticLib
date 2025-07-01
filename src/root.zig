const zig = "Zig";

pub export fn helloFrom() usize {
    return @intFromPtr(zig);
}
