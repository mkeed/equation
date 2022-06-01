const std = @import("std");

pub const Calc = struct {
    alloc: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator) Calc {
        return .{
            .alloc = alloc,
        };
    }
    pub fn deinit(self: *Calc) void {
        _ = self;
    }
    const Result = union(enum) {
        exit: void,
        result: []const u8,
    };
    pub fn exec(self: *Calc, statement: []const u8) !Result {
        _ = self;
        if (std.mem.indexOf(u8, statement, "quit") != null) return .exit;
        return Result{ .result = statement };
    }
};
