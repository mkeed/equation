const UnitDimension = struct {
    Time: isize = 0,
    Length: isize = 0,
    Mass: isize = 0,
    Current: isize = 0,
    Temperature: isize = 0,
    Amount: isize = 0,
    Luminous: isize = 0,
};

const ConversionRate = struct {
    ratio: f64,
    baseUnit: *const UnitDefinition,
};

const UnitDefiniton = struct {
    name: []const u8,
    dimension: UnitDimension,
    conversion: ?ConversionRate,
};

pub const Metre = UnitDefiniton{
    .name = "Metre",
    .dimension = .{
        .Length = 1,
    },
    .conversion = null,
};

pub const Yard = UnitDefinition{
    .name = "Yard",
    .dimension = .{
        .Length = 1,
    },
    .conversion = .{
        .ratio = 0.9144,
        .baseUnit = &Metre,
    },
};
