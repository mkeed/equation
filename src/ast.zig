const std = @import("std");

pub const Constant = struct {};

pub const ASTNode = union(enum) {
    constant: Constant,
    pub fn deinit(_: ASTNode) void {}
};

pub const AST = struct {
    nodes: std.ArrayList(ASTNode),
    pub fn init(alloc: std.mem.Allocator) AST {}
    pub fn deinit(self: *AST) void {
        for (self.nodes.items) |item| {
            item.deinit();
        }
        self.nodes.deinit();
    }
    pub fn addConstant(self: *AST, value: Constant) !void {}
};
