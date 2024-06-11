pub const CardRank = enum {
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    jack,
    queen,
    king,
    ace,
};

pub const CardSuit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
};

pub const Card = struct {
    rank: CardRank,
    suit: CardSuit,

    pub fn isEquilTo(self: Card, other: Card) bool {
        return self.rank == other.rank and self.suit == other.suit;
    }
};
