const Decimal = struct { value: usize };
const Fraction = struct { numerator: usize, demoninator: usize };
const Number = union(enum) {
    decimal: Decimal,
    fraction: Fraction,
};
