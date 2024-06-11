const Card = @import("./card.zig").Card;
const ChipsType = @import("./constants.zig").ChipsType;

pub const PlayerHand = struct {
    card1: Card,
    card2: Card,
};

pub const Player = struct {
    hand: ?PlayerHand,
    chips_stack: ChipsType,
};
