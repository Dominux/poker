const std = @import("std");
const expect = std.testing.expect;
const expectError = std.testing.expectError;
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
const PokerError = @import("./errors.zig").PokerError;

const TableCards = struct {
    card1: ?Card,
    card2: ?Card,
    card3: ?Card,
    card4: ?Card,
    card5: ?Card,

    pub fn default() TableCards {
        return .{
            .card1 = undefined,
            .card2 = undefined,
            .card3 = undefined,
            .card4 = undefined,
            .card5 = undefined,
        };
    }
};

const RoomSettings = struct {
    init_chips_stack: ChipsType,
    big_blind: ChipsType,
    small_blind: ChipsType,
};

const cards_amount: comptime_int = 52;
const buffer_size: comptime_int = ((@bitSizeOf(Player) / 8) * constants_mod.MAX_PLAYERS) + ((@bitSizeOf(Card) / 8) * cards_amount);

const Room = struct {
    players: ArrayList(Player),
    cards_deck: ArrayList(Card),
    table_cards: TableCards,
    settings: RoomSettings,

    bank: ChipsType,

    pub fn init(allocator: std.mem.Allocator, settings: RoomSettings) !Room {
        const players = try ArrayList(Player).initCapacity(allocator, constants_mod.MAX_PLAYERS);
        const cards_deck = try ArrayList(Card).initCapacity(allocator, cards_amount);
        const table_cards = TableCards.default();

        return .{ .players = players, .cards_deck = cards_deck, .table_cards = table_cards, .settings = settings, .bank = 0 };
    }

    pub fn addPlayer(self: *Room, player: Player) !void {
        if (self.players.items.len == constants_mod.MAX_PLAYERS) return PokerError.RoomIsFull;

        try self.players.append(player);
    }

    // pub fn removePlayer(self: Room, player: Player) PokerError!void {
    //     if (self.players.len == 0) return PokerError.RoomIsEmpty;
    // }

    pub fn deinit(self: Room) void {
        defer self.players.deinit();
        defer self.cards_deck.deinit();
    }
};

test "Room.deinit buffer size" {
    var buffer: [buffer_size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const room = try Room.init(allocator, RoomSettings{ .init_chips_stack = 1000, .big_blind = 0, .small_blind = 0 });
    defer room.deinit();
}

fn testCreatePlayer() Player {
    const card1 = Card{ .rank = CardRank.ace, .suit = CardSuit.clubs };
    const card2 = Card{ .rank = CardRank.ace, .suit = CardSuit.clubs };
    const hand = PlayerHand{ .card1 = card1, .card2 = card2 };

    return Player{ .chips_stack = 0, .hand = hand };
}

test "Room.addPlayer" {
    const allocator = std.testing.allocator;

    var room = try Room.init(allocator, RoomSettings{ .init_chips_stack = 1000, .big_blind = 0, .small_blind = 0 });
    defer room.deinit();

    // checking adding players correctly
    for (0..constants_mod.MAX_PLAYERS) |_| {
        const player = testCreatePlayer();
        try room.addPlayer(player);
    }

    // checking adding player when the room is full
    const player = testCreatePlayer();
    const result = room.addPlayer(player);
    try expectError(PokerError.RoomIsFull, result);
}
