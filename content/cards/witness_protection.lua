SMODS.Joker {
    key = 'witness_protection',
    
    atlas = 'ABNJokerSheet21',
    pos = { x = 6, y = 5 },
    
    cost = 8,
    rarity = 3,
    
    abn_coder = "LasagnaFelidae",
    
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = {
        extra = {
            xchips = 1.5,
            chips = 10,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        ctr = self:countFlippedRarities()
        ctj = self:countFlippedJokers()
        return {
            vars = {
                card.ability.extra.xchips,
                card.ability.extra.chips,
                math.max(1,card.ability.extra.xchips * ctr),
                card.ability.extra.chips * ctj
            }
        }
    end,
    countFlippedJokers = function()
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.facing == 'back' then -- adjust if your mod uses a different flag
                    count = count + 1
                end
            end
        end
        return count
    end,
    
    countFlippedRarities = function()
        local rarities = {}
        local unique = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.facing == 'back' then -- or whatever the mod uses for "flipped"
                    local rar = j.config.center.rarity
                    if rar and not rarities[rar] then
                        rarities[rar] = true
                        unique = unique + 1
                    end
                end
            end
        end
        return unique
    end,
    
    
    calculate = function(self, card, context)
        
        
        if context.joker_main then
            local unique = self:countFlippedRarities()
            if unique > 0 then
                local xchips = math.max(1,card.ability.extra.xchips * unique)
                return {
                    xchips = xchips,
                    
                }
            end
        end
        
        if context.individual and context.cardarea == G.play then
            if card.facing == 'back' then
                local flipped = self:countFlippedJokers()
                if flipped > 0 then
                    return {
                        chips = card.ability.extra.chips * flipped,
                    }
                end
            end
        end
    end,
    
    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return false end
        for _, j in ipairs(G.jokers.cards) do
            if j.facing == 'back' then
                return true
            end
        end
        return false
    end,
    
    abn_artist_credits = { artist = "0kronix" },
}