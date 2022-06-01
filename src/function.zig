const std = @import("std");
const Core = @import("Core.zig");

pub const FunctionError = error{
    FatalError,
    AllocError,
};

pub const EquationFunction = fn (core: Core.Core, args: []Core.Value) FunctionError!Core.Value;

pub fn abs(core: Core.Core, args: []Core.Value) !Core.Value {
    if (args.len != 1) return FunctionError.FatalError;
    const val = args[0];
    switch (val) {
        .number => |num| return Core.Value{ .Number = @fabs(num) },
        .array => |arr| {
            var result = std.ArrayList(Core.Value).init(core.functionAlloc);
            result.resize(arr.len) catch {
                return FunctionError.AllocError;
            };
            for (arr) |item| {
                result.append(@fabs(item)) catch unreachable; // Shouldnt be able to throw as resized before loop
            }
            return result.items;
        },
    }
}

//pub fn aver
