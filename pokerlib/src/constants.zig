pub const ChipsType = u32; // max value ~ 4 billions

// 16 players with 100M stacks will be less than max ChipsSize,
// so it's not gonna cause an overflow
pub const MAX_PLAYERS = 16;
pub const MAX_STACK = 100_000_000;
