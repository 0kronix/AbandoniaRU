SMODS.Joker {
    key = 'rage_baiter',
    
    atlas = 'ABNJokerSheet17',
    
    pos = { x = 3, y = 2 },
    
    cost = 6,
    rarity = 1,
    
    abn_coder = "LasagnaFelidae",
    
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    
    config = {
        extra = {
            chips = 0,
            mult = 0,
            chips_m = 25,
            mult_m = 8,
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
        if context.before and G.GAME.hands[context.scoring_name].level > 1 and not context.blueprint then
            SMODS.upgrade_poker_hands({
                hands = context.scoring_name, 
                parameters = nil, 
                level_up = -1,
                func = nil,
                from = card,
                instant = nil
            })
            card.abn_triggered = true
        end
        if context.joker_main then
            if card.abn_triggered and not context.blueprint then
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
                card.abn_triggered = false
            end
            
            
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end,
    abn_artist_credits = { artist = "Gud" },
}
