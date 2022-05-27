const std = @import("std");
const ast = @import("ast.zig");

pub const Result = union(enum) {
    Integer: isize,
};

const Operation = struct {
    pub const OpType = enum {
        Multiply,
        Divide,
        Add,
        Subtract,
    };
    op: OpType,
    lhs: usize,
    rhs: usize,
};

const Node = union(enum) {
    constant: Result,
    operation: Operation,
};

const Token = union(enum) {
    operation: Operation.OpType,
    value: Result,
};

pub fn parseNumber(eq: []const u8, idx: *usize) !Result {
    const idxStart = idx.*;

    var radix: ?u8 = null;

    while (idx.* < eq.len) : (idx.* += 1) {
        switch (eq[idx.*]) {
            '0'...'1' => {},
            '8', '9' => {
                if (radix) |r| {
                    if (r == 16) continue;
                    if (r == 2 or r == 8) return error.InvalidNumber;
                }
            },
            '2'...'7' => {
                if (radix) |r| {
                    if (r == 16 or r == 8) continue;
                    if (r == 2) return error.InvalidNumber;
                }
            },
            'a'...'f', 'A'...'F' => {
                if (radix) |r| {
                    if (r == 16) continue;
                }
                return error.InvalidNumber;
            },
            'x' => {
                if (idxStart + 1 == idx.*) continue;
                break;
            },
            else => break,
        }
    }
    if (radix == null) radix = 10;
    const res = try std.fmt.parseInt(isize, eq[idxStart..idx.*], radix.?);
    return Result{
        .Integer = res,
    };
}

pub const Equation = struct {
    alloc: std.mem.Allocator,
    eq: []const u8,

    pub fn compile(alloc: std.mem.Allocator, eq: []const u8) !Equation {
        var tokens = std.ArrayList(Token).init(alloc);
        defer tokens.deinit();
        var idx: usize = 0;
        while (idx < eq.len) {
            switch (eq[idx]) {
                '0'...'9' => {
                    var number = try parseNumber(eq, &idx);
                    try tokens.append(.{ .value = number });
                },
                '+' => {
                    try tokens.append(.{ .operation = .Add });
                    idx += 1;
                },
                '-' => {
                    try tokens.append(.{ .operation = .Subtract });
                    idx += 1;
                },
                '*' => {
                    try tokens.append(.{ .operation = .Multiply });
                    idx += 1;
                },
                '/' => {
                    try tokens.append(.{ .operation = .Divide });
                    idx += 1;
                },
                else => return error.NotImplemented,
            }
        }

        var tokIter = arrListIter(Token).init(tokens.items);
        var tree = ast.AST.init(alloc);
        errdefer tree.deinit();
        while (tokIter.next()) |token| {
            std.log.err("{}", .{token});
            switch (token) {
                .value => |v| {},
                .operation => |_| {},
            }
        }

        return Equation{
            .alloc = alloc,
            .eq = eq,
            .nodes = nodes,
        };
    }
    pub fn execute(self: Equation) Result {
        _ = self;
        return .{ .Integer = 1 };
    }
    pub fn deinit(self: *Equation) void {
        self.nodes.deinit();
    }
};

fn arrListIter(comptime T: type) type {
    return struct {
        const Self = @This();
        list: []const T,
        index: usize,
        pub fn init(list: []const T) Self {
            return .{
                .list = list,
                .index = 0,
            };
        }
        pub fn peek(self: *Self) ?T {
            if (self.index >= self.list.len) return null;
            return self.list[self.index];
        }
        pub fn next(self: *Self) ?T {
            if (self.index >= self.list.len) return null;

            const ret = self.list[self.index];
            self.index += 1;
            return ret;
        }
    };
}

const TestCase = struct {
    eq: []const u8,
    result: Result,
};

test {
    const tests = [_]TestCase{
        .{
            .eq = "1+8/4",
            .result = .{ .Integer = 3 },
        },
    };

    const alloc = std.testing.allocator;
    for (tests) |tc| {
        var eq = try Equation.compile(alloc, tc.eq);
        defer eq.deinit();
        var res = eq.execute();
        try std.testing.expectEqual(tc.result, res);
    }
}
