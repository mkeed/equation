const UnitDimension = struct {
    Time: isize = 0,
    Length: isize = 0,
    Mass: isize = 0,
    Current: isize = 0,
    Temperature: isize = 0,
    Amount: isize = 0,
    Luminous: isize = 0,
};

pub const UnitRatio = struct {
    name: []const u8,
    ratio: f64,
};

pub const UnitsDefinition = struct {
    dimension: UnitDimension,
    baseUnitName: []const u8,
    unitRatio: []const UnitRatio,
};

const LengthUnits = UnitsDefinition{
    .dimension = .{ .length = 1 },
    .baseUnitName = "Metre",
    .unitRatio = &.{
        .{ .name = "KiloMetre", .ratio = 1000 },
        .{ .name = "Foot", .ratio = 0.3048 },
        .{ .name = "Inch", .ratio = 0.0254 },
        .{ .name = "Yard", .ratio = 0.9144 },
        .{ .name = "Mile", .ratio = 1.609344 },
    },
};

const AreaUnits = UnitsDefinition{
    .dimension = .{ .length = 2 },
    .baseUnitName = "SquareMetre",
    .unitRatio = &.{
        .{ .name = "acre", .ratio = 4046.873 },
        .{ .name = "Hectare", .ratio = 10000 },
        .{ .name = "SquareInch", .ratio = 0.0064516 },
    },
};
