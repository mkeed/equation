const std = @import("std");

pub const Number = struct {
    pub fn decodeNumber(str: []const u8) !Number {
        const val = try std.fmt.parseFloat(f64, str);
        return Number{ .value = val };
    }
    value: f64,
    pub fn multiply(self: Number, other: Number) Number {
        return .{ .value = self.value * other.value };
    }
    pub fn divide(self: Number, other: Number) Number {
        return .{ .value = self.value / other.value };
    }
    pub fn add(self: Number, other: Number) Number {
        return .{ .value = self.value + other.value };
    }
    pub fn subtract(self: Number, other: Number) Number {
        return .{ .value = self.value - other.value };
    }
};

test {
    const val = try Number.decodeNumber("1.00");
    try std.testing.expectEqual(val.value, 1);
}
