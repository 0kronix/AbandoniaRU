SMODS.Joker {
    key = "ruinous_joker",
    config = { extra = { ruinous_limit_bonus = 1 } },
    pos = { x = 9, y = 1 },
    atlas = "ABNJokerSheet19",
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.ruinous_limit_bonus } }
    end,

    in_pool = function(self, args)
        if G.ruinous_powers and #G.ruinous_powers.cards > 0 then
            return true
        end
        return false
    end,

    add_to_deck = function(self, card, from_debuff)
        if G.ruinous_powers then
            G.ruinous_powers.config.card_limit = G.ruinous_powers.config.card_limit + card.ability.extra.ruinous_limit_bonus
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.ruinous_powers then
            G.ruinous_powers.config.card_limit = G.ruinous_powers.config.card_limit - card.ability.extra.ruinous_limit_bonus
        end
    end,

    abn_artist_credits = {
        artist = "yeahhpiehh",
    },
}
