const std = @import("std");
const units = @import("units.zig");
const number = @import("Number.zig");

pub const TaggedUnit = struct {
    value: number.Number,
    unit: *const units.Unit,
    pub fn multiply(self: TaggedUnit, other: TaggedUnit) !TaggedUnit {
        const num = self.value.multiply(other.value);
        const resultUnit = self.unit.getDimensions().multiply(other.unit.getDimensions());
        const finalUnit = units.Unit.findBestUnit(resultUnit) orelse
            return error.NoUnit;

        return TaggedUnit{
            .value = num,
            .unit = finalUnit,
        };
    }
};

test {
    const speed = TaggedUnit{
        .value = try number.Number.decodeNumber("100"),
        .unit = try units.Unit.decodeFullName("MetersPerSecond"),
    };
    const time = TaggedUnit{
        .value = try number.Number.decodeNumber("10"),
        .unit = try units.Unit.decodeFullName("Second"),
    };

    const res = try speed.multiply(time);
    std.log.err("{}", .{res});
}
