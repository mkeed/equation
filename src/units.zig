//units from https://physics.nist.gov/cuu/Units/units.html

const UnitDimension = struct {
    Time: isize = 0,
    Length: isize = 0,
    Mass: isize = 0,
    Current: isize = 0,
    Temperature: isize = 0,
    Amount: isize = 0,
    Luminous: isize = 0,

    pub fn multiply(a: UnitDimension, b: UnitDimension) UnitDimension {
        return .{
            .Time = a.Time + b.Time,
            .Length = a.Length + b.Length,
            .Mass = a.Mass + b.Mass,
            .Current = a.Current + b.Current,
            .Temperature = a.Temperature + b.Temperature,
            .Amount = a.Amount + b.Amount,
            .Luminous = a.Luminous + b.Luminous,
        };
    }
    pub fn divide(a: UnitDimension, b: UnitDimension) UnitDimension {
        return .{
            .Time = a.Time - b.Time,
            .Length = a.Length - b.Length,
            .Mass = a.Mass - b.Mass,
            .Current = a.Current - b.Current,
            .Temperature = a.Temperature - b.Temperature,
            .Amount = a.Amount - b.Amount,
            .Luminous = a.Luminous - b.Luminous,
        };
    }
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

    pub fn getDimensions(self: Unit) UnitDimension {
        switch (self) {
            .base => |b| {
                return b.dimension;
            },
            .derived => |d| {
                var dim = UnitDimension{};
                if (d.multipliers) |mult| {
                    for (mult) |m| {
                        dim = dim.multiply(m.getDimensions());
                    }
                }
                if (d.dividers) |divider| {
                    for (divider) |div| {
                        dim = dim.divide(div.getDimensions());
                    }
                }
                return dim;
            },
        }
    }
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
        .shortName = "Hz",
        .dividers = &.{&Second},
    },
};

const Newton = Unit{
    .derived = DerivedUnit{
        .name = "Newton",
        .shortName = "N",
        .multipliers = &.{ &Meter, &Kilogram },
        .dividers = &.{ &Second, &Second },
    },
};

const Pascal = Unit{
    .derived = DerivedUnit{
        .name = "Pascal",
        .shortName = "Pa",
        .multipliers = &.{&Newton},
        .dividers = &.{&SquareMeter},
    },
};

const Joule = Unit{
    .derived = DerivedUnit{
        .name = "Joule",
        .shortName = "J",
        .multipliers = &.{&Newton},
        .dividers = &.{&Meter},
    },
};

const Watt = Unit{
    .derived = DerivedUnit{
        .name = "Watt",
        .shortName = "W",
        .multipliers = &.{&Joule},
        .dividers = &.{&Second},
    },
};

const Coulomb = Unit{
    .derived = DerivedUnit{
        .name = "Coloumb",
        .shortName = "C",
        .multipliers = &.{ &Second, &Ampere },
    },
};

const Volt = Unit{
    .derived = DerivedUnit{
        .name = "Vold",
        .shortName = "V",
        .multipliers = &.{&Watt},
        .dividers = &.{&Ampere},
    },
};

const Farad = Unit{
    .derived = DerivedUnit{
        .name = "Farad",
        .shortName = "F",
        .multipliers = &.{&Coulomb},
        .dividers = &.{&Volt},
    },
};

const Ohm = Unit{
    .derived = DerivedUnit{
        .name = "Ohm",
        .shortName = "Ω",
        .multipliers = &.{&Volt},
        .dividers = &.{&Ampere},
    },
};

const Siemens = Unit{
    .derived = DerivedUnit{
        .name = "Siemens",
        .shortName = "S",
        .multipliers = &.{&Ampere},
        .dividers = &.{&Volt},
    },
};

const Weber = Unit{
    .derived = DerivedUnit{
        .name = "Weber",
        .shortName = "Wb",
        .multipliers = &.{&Volt},
        .dividers = &.{&Second},
    },
};

const Tesla = Unit{
    .derived = DerivedUnit{
        .name = "Tesla",
        .shortName = "T",
        .multipliers = &.{&Weber},
        .dividers = &.{&SquareMeter},
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
    &Farad,
    &Ohm,
    &Siemens,
    &Weber,
    &Tesla,
};

const AlternateUnit = struct {
    name: []const u8,
    shortName: ?[]const u8 = null,
    base: number.Number,
};

test {
    _ = units;
}
