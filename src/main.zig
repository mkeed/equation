const std = @import("std");
const repl = @import("Repl.zig");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    try repl.run(alloc);
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
