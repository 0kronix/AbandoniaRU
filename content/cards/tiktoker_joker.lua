
SMODS.Joker {
    key = 'tiktoker_joker',
    
    atlas = 'ABNJokerSheet21',
    pos = { x = 3, y = 6 },
    
    cost = 4,
    rarity = 1,
    
    abn_coder = "LasagnaFelidae",
    
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    
    config = {
        extra = {
            mult = 1,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                card.ability.extra.mult,
            } 
        }
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card and context.other_card:is_suit("Hearts") == false then

                local ct = 0

                if G.play and G.play.cards then
                    for _, played_card in ipairs(context.scoring_hand) do
                        if played_card:is_suit("Hearts") and not played_card.debuff then
                            ct = ct + 1
                        end
                    end
                end
                
                if ct > 0 then
                    return {
                        mult = card.ability.extra.mult * ct,
                    }
                end

            end
        end
    end,
    abn_artist_credits = { artist = "comykel" },
}

