//units from https://physics.nist.gov/cuu/Units/units.html

const UnitDimension = struct {
    Time: isize = 0,
    Length: isize = 0,
    Mass: isize = 0,
    Current: isize = 0,
    Temperature: isize = 0,
    Amount: isize = 0,
    Luminous: isize = 0,
};

const BaseUnit = struct {
    name: []const u8,
    shortName: []const u8,
    dimension: UnitDimension,
};

const Meter = Unit{
    .base = BaseUnit{
        .name = "Meter",
        .shortName = "m",
        .dimension = .{ .Length = 1 },
    },
};

const Kilogram = Unit{
    .base = BaseUnit{
        .name = "Kilogram",
        .shortName = "kg",
        .dimension = .{ .Mass = 1 },
    },
};

const Second = Unit{
    .base = BaseUnit{
        .name = "Second",
        .shortName = "s",
        .dimension = .{ .Time = 1 },
    },
};

const Ampere = Unit{
    .base = BaseUnit{
        .name = "Ampere",
        .shortName = "A",
        .dimension = .{ .Current = 1 },
    },
};

const Kelvin = Unit{
    .base = BaseUnit{
        .name = "Kelvin",
        .shortName = "K",
        .dimension = .{ .Temperature = 1 },
    },
};

const Mole = Unit{
    .base = BaseUnit{
        .name = "Mole",
        .shortName = "mol",
        .dimension = .{ .Amount = 1 },
    },
};

const Candela = Unit{
    .base = BaseUnit{
        .name = "Candela",
        .shortName = "cd",
        .dimension = .{ .Luminous = 1 },
    },
};

const DerivedUnit = struct {
    name: []const u8,
    shortName: ?[]const u8 = null,
    multipliers: ?[]const *const Unit = null,
    dividers: ?[]const *const Unit = null,
};

const Unit = union(enum) {
    base: BaseUnit,
    derived: DerivedUnit,
};

const SquareMeter = Unit{
    .derived = .{
        .name = "SquareMeter",
        .multipliers = &.{ &Meter, &Meter },
    },
};

const CubicMeter = Unit{
    .derived = DerivedUnit{
        .name = "CubicMeter",
        .multipliers = &.{ &Meter, &Meter, &Meter },
    },
};

const MetersPerSecond = Unit{
    .derived = DerivedUnit{
        .name = "MetersPerSecond",
        .multipliers = &.{&Meter},
        .dividers = &.{&Second},
    },
};

const MetersPerSecondSquared = Unit{
    .derived = DerivedUnit{
        .name = "MetersPerSecondSquared",
        .multipliers = &.{&Meter},
        .dividers = &.{ &Second, &Second },
    },
};

const ReciprocalMeter = Unit{
    .derived = DerivedUnit{
        .name = "ReciprocalMeter",
        .shortName = "m^-1",
        .dividers = &.{&Meter},
    },
};

const KilogramPerCubicMeter = Unit{
    .derived = DerivedUnit{
        .name = "KilogramPerCubicMeter",
        .multipliers = &.{&Kilogram},
        .dividers = &.{ &Meter, &Meter, &Meter },
    },
};

const CubicMeterPerKilogram = Unit{
    .derived = DerivedUnit{
        .name = "CubicMeterPerKilogram",
        .multipliers = &.{ &Meter, &Meter, &Meter },
        .dividers = &.{&Kilogram},
    },
};

const AmperePerSquareMeter = Unit{
    .derived = DerivedUnit{
        .name = "AmperePerSquareMeter",
        .multipliers = &.{&Ampere},
        .dividers = &.{ &Meter, &Meter },
    },
};

const AmperePerMeter = Unit{
    .derived = DerivedUnit{
        .name = "AmperePerMeter",
        .multipliers = &.{&Ampere},
        .dividers = &.{&Meter},
    },
};

const CandelaPerSquareMeter = Unit{
    .derived = DerivedUnit{
        .name = "CandelaPerSquareMeter",
        .multipliers = &.{&Candela},
        .dividers = &.{ &Meter, &Meter },
    },
};

const Hertz = Unit{
    .derived = DerivedUnit{
        .name = "Hertz",
        .dividers = &.{&Second},
    },
};

const Newton = Unit{
    .derived = DerivedUnit{
        .name = "Newton",
        .multipliers = &.{ &Meter, &Kilogram },
        .dividers = &.{ &Second, &Second },
    },
};

const Pascal = Unit{
    .derived = DerivedUnit{
        .name = "Pascal",
        .multipliers = &.{&Newton},
        .dividers = &.{&SquareMeter},
    },
};

const Joule = Unit{
    .derived = DerivedUnit{
        .name = "Joule",
        .multipliers = &.{&Newton},
        .dividers = &.{&Meter},
    },
};

const Watt = Unit{
    .derived = DerivedUnit{
        .name = "Watt",
        .multipliers = &.{&Joule},
        .dividers = &.{&Second},
    },
};

const Coulomb = Unit{
    .derived = DerivedUnit{
        .name = "Coloumb",
        .multipliers = &.{ &Second, &Ampere },
    },
};

const Volt = Unit{
    .derived = DerivedUnit{
        .name = "Vold",
        .multipliers = &.{&Watt},
        .dividers = &.{&Ampere},
    },
};

const Farad = Unit{
    .derived = DerivedUnit{
        .name = "Farad",
        .multipliers = &.{&Coulomb},
        .dividers = &.{&Volt},
    },
};

const Ohm = Unit{
    .derived = DerivedUnit{
        .name = "Ohm",
        .multipliers = &.{&Volt},
        .dividers = &.{&Ampere},
    },
};

const Siemens = Unit{
    .derived = DerivedUnit{
        .name = "Siemens",
        .multipliers = &.{&Ampere},
        .dividers = &.{&Volt},
    },
};

const Weber = Unit{
    .derived = DerivedUnit{
        .name = "Weber",
        .multipliers = &.{&Volt},
        .dividers = &.{&Second},
    },
};
const units = [_]*const Unit{
    &Meter,
    &Kilogram,
    &Second,
    &Ampere,
    &Kelvin,
    &Mole,
    &Candela,
    &SquareMeter,
    &CubicMeter,
    &MetersPerSecond,
    &MetersPerSecondSquared,
    &ReciprocalMeter,
    &KilogramPerCubicMeter,
    &CubicMeterPerKilogram,
    &AmperePerSquareMeter,
    &AmperePerMeter,
    &CandelaPerSquareMeter,
    &Hertz,
    &Newton,
    &Pascal,
    &Joule,
    &Watt,
};

test {
    _ = units;
}
