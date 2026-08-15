SMODS.Joker {
    key = 'lunar_conspiracy',

    atlas = 'ABNJokerSheet17',

    pos = { x = 9, y = 5 },

    cost = 6,
    rarity = 2,

    abn_coder = "LasagnaFelidae",

    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    config = {
        extra = {
            chips = 0,
            mult = 0,
            chips_m = 2,
            mult_m = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                card.ability.extra.chips, 
                card.ability.extra.mult,
                card.ability.extra.chips_m, 
                card.ability.extra.mult_m,
            } 
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            for _, consumeable in ipairs(G.consumeables.cards) do
                if consumeable.ability 
                and consumeable.ability.set == "Planet" 
                and consumeable.ability.hand_type 
                and not context.blueprint then
                    local hand_type = consumeable.ability.hand_type
                    if context.scoring_name == hand_type then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_value = "chips_m",
                            no_message = true
                        })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "mult",
                            scalar_value = "mult_m",
                        })
                    end
                end
            end

            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end,
    abn_artist_credits = { artist = "B.B.B.B." },
}
