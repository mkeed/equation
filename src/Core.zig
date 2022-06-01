const std = @import("std");

pub const Core = struct {};

pub const Value = union(enum) {
    number: f64,
    array: []Value,
};
