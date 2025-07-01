const zig = "Zig";

pub export fn helloFrom() usize {
    // Note that the cortex target does not support returning [:0]u8.
    // So we cast to usize, and then back to char * in c.
    return @intFromPtr(zig);
}
