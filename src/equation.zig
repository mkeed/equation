const std = @import("std");

pub const Result = union(enum) {
    Integer: isize,
};

const Operation = struct {
    pub const OpType = enum {
        Multiply,
        Subtrace,
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
    operation: Operation.Optype,
    Value: Result,
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
    nodes: std.ArrayList(Node),

    pub fn compile(alloc: std.mem.Allocator, eq: []const u8) !Equation {
        var tokens = std.ArrayList(Token).init(alloc);
        defer tokens.deinit();
        var idx: usize = 0;
        while (idx < eq.len) {
            switch (eq[idx]) {
                '0'...'9' => {
                    var number = try parseNumber(eq, &idx);
                    try tokens.append(.{ .Value = number });
                },
                '+' => {
                    try tokens.append(.Add);
                    idx += 1;
                },
                '-' => {
                    try tokens.append(.Subtract);
                    idx += 1;
                },
                '*' => {
                    try tokens.append(.Multiply);
                    idx += 1;
                },
                '/' => {
                    try tokens.append(.Divide);
                    idx += 1;
                },
                else => return error.NotImplemented,
            }
        }
        var curNode: ?usize = null;
        var nodes = std.ArrayList(Node).init(alloc);
        errdefer nodes.deinit();

        var tokIter = arrListIter(Token).init(tokens.items);

        while (tokIter.next()) |token| {
            std.log.err("{}", .{token});
            switch (token) {
                .Value => |v| {
                    curNode = nodes.items.len;
                    try nodes.append(.{ .constant = v });
                },
                .operation => |op| {},
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
            .eq = "1+1",
            .result = .{ .Integer = 2 },
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
