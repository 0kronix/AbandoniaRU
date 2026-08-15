SMODS.Joker {
    key = 'buccaneer_joker',
    
    atlas = 'ABNJokerSheet17',
    
    pos = { x = 9, y = 1 },
    
    cost = 6,
    rarity = 1,
    
    abn_coder = "LasagnaFelidae",
    
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = {
        extra = {
            mult = 10,
            dollars = 2,
            mult_odds = 4,
            dollars_odds = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        local m_n, m_d = SMODS.get_probability_vars(card, 1, card.ability.extra.mult_odds, 'abn_buccaneer_joker')
        local d_n, d_d = SMODS.get_probability_vars(card, 1, card.ability.extra.dollars_odds, 'abn_buccaneer_joker')
        return { 
            vars = { 
                d_n, d_d,
                card.ability.extra.dollars, 
                m_n, m_d,
                card.ability.extra.mult,
                
            } 
        }
    end,
    removed_from_deck = function (self, from_debuff)
        for _, playing_card in ipairs(G.playing_cards) do
            if (playing_card.ability.abn_forced_highlight == true or playing_card.ability.forced_selection == true) and playing_card.base.suit == "abn_Anchor" then
                playing_card.ability.abn_forced_highlight = false
                playing_card.ability.forced_selection = false
            end
        end

    end,
    
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.base.suit == "abn_Anchor" then
            local ret = {}
            if SMODS.pseudorandom_probability(card, 'abn_buccaneer_joker', 1, card.ability.extra.mult_odds ) then
                ret.mult = card.ability.extra.mult
                ret.message_card = context.other_card
            end
            if SMODS.pseudorandom_probability(card, 'abn_buccaneer_joker', 1, card.ability.extra.dollars_odds) then
                ret.dollars = card.ability.extra.dollars
                ret.message_card = context.other_card
            end
            if context.other_card.ability.abn_forced_highlight == true or context.other_card.ability.forced_selection == true then
                context.other_card.ability.abn_forced_highlight = false
                context.other_card.ability.forced_selection = false
            end
            return ret
        end
        if context.discard and context.other_card.base.suit == "abn_Anchor" then
            if context.other_card.ability.abn_forced_highlight == true or context.other_card.ability.forced_selection == true then
                context.other_card.ability.abn_forced_highlight = false
                context.other_card.ability.forced_selection = false
            end
        end
    end,
    in_pool = function(self, args)
        if not G.playing_cards then return false end
        for _, playing_card in ipairs(G.playing_cards) do
        if playing_card.base.suit == "abn_Anchor" then
            return true
        end
        end
        return false
    end,
    abn_artist_credits = { artist = "Nice Cream" },
}


local cardUpdateHook = Card.update
function Card:update(dt)
    local x = cardUpdateHook(self,dt)
    if self.ability.abn_forced_hihglight and self.area and self.area.highlighted then
        local isAlreadyInHighlighted = false
        for gg,gk in ipairs(self.area.highlighted) do
            if gk == self then
                isAlreadyInHighlighted = true
                break
            end
        end
        if not isAlreadyInHighlighted and #self.area.highlighted < self.area.config.highlighted_limit then
            self:highlight(true)
            self.area:add_to_highlighted(self)
            self.ability.forced_selection = true
        end
    end
end

local cardHighlightHook = Card.highlight
function Card:highlight(dt)
    local x = cardHighlightHook(self,dt)
    if self.base and self.base.suit == "abn_Anchor" 
    and self.area and self.area.highlighted 
    and next(SMODS.find_card("j_abn_buccaneer_joker")) then
        self.ability.abn_forced_highlight = true
        self.ability.forced_selection = true
    end
end