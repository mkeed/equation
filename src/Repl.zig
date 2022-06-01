const std = @import("std");
const calculate = @import("calculate.zig");

pub fn run(alloc: std.mem.Allocator) !void {
    _ = alloc;
    var buf: [4096]u8 = undefined;

    var input = std.io.getStdIn().reader();
    var output = std.io.getStdOut().writer();
    var calc = calculate.Calc.init(alloc);
    defer calc.deinit();

    while (true) {
        try std.fmt.format(output, "> ", .{});
        const len = try input.read(buf[0..]);
        switch (try calc.exec(buf[0..len])) {
            .exit => return,
            .result => |res| {
                try std.fmt.format(output, ">:{s}", .{res});
            },
        }
    }
}
