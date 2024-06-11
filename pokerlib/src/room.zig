const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;
const ArrayList = std.ArrayList;

const players_mod = @import("./player.zig");
const Player = players_mod.Player;
const PlayerHand = players_mod.PlayerHand;
const cards_mod = @import("./card.zig");
const Card = cards_mod.Card;
const CardRank = cards_mod.CardRank;
const CardSuit = cards_mod.CardSuit;
const constants_mod = @import("./constants.zig");
const ChipsType = constants_mod.ChipsType;

const TableCards = struct {
    card1: ?Card,
    card2: ?Card,
    card3: ?Card,
    card4: ?Card,
    card5: ?Card,
};

const RoomSettings = struct {
    init_chips_stack: ChipsType,
    big_blind: ChipsType,
    small_blind: ChipsType,
};

const Room = struct {
    players: []Player,
    cards_deck: []Card,
    table_cards: TableCards,

    bank: ChipsType,

    // pub fn init(settings: RoomSettings) Room {
    //     var buffer: [1000]u8 = undefined;
    //     var fba = std.heap.FixedBufferAllocator.init(&buffer);

    //     return Room {
    //         .players =
    //     }
    // }
};

test "LMAO" {
    const buffer_size: comptime_int = (@bitSizeOf(Player) / 8) * constants_mod.MAX_PLAYERS;

    var buffer: [buffer_size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var list = try ArrayList(Player).initCapacity(allocator, constants_mod.MAX_PLAYERS);
    defer list.deinit();

    for (0..16) |_| {
        const card1 = Card{ .rank = CardRank.ace, .suit = CardSuit.clubs };
        const card2 = Card{ .rank = CardRank.ace, .suit = CardSuit.clubs };
        const hand = PlayerHand{ .card1 = card1, .card2 = card2 };

        const player = Player{ .chips_stack = 0, .hand = hand };

        try list.append(player);
    }
}
