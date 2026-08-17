local old_check_for_buy_space = G.FUNCS.check_for_buy_space

G.FUNCS.check_for_buy_space = function(card)
	
	if card.config and card.config.center and card.config.center.key and card.config.center.key == 'j_abn_oopsy_daisy' then
		return true
	end
	
	if card.ability and card.ability.set == 'Joker' then
        if next(SMODS.find_card('j_abn_oopsy_daisy')) then
            return #G.consumeables.cards < G.consumeables.config.card_limit
        end
    end

    return old_check_for_buy_space(card)
end

local add_to_deckref = Card.add_to_deck

function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if not from_debuff then
            
            if self.ability and self.ability.set == "Joker" and next(SMODS.find_card('j_abn_oopsy_daisy')) then
				self:start_dissolve()
				local copy = copy_card(self)
				G.consumeables:emplace(copy)
				copy:start_materialize(nil, nil)
            end
        end
    end

    return add_to_deckref(self, from_debuff)
end

local old_can_select_card = G.FUNCS.can_select_card

G.FUNCS.can_select_card = function(e)
    local card = e.config and e.config.ref_table
    
    if card and card.ability and card.ability.set == 'Joker' then
        local has_oopsy = next(SMODS.find_card('j_abn_oopsy_daisy'))
        local is_oopsy = card.config and card.config.center and card.config.center.key == 'j_abn_oopsy_daisy'
        
        if has_oopsy or is_oopsy then
            local is_negative = card.edition and card.edition.negative
            local has_consumeable_space = #G.consumeables.cards < G.consumeables.config.card_limit
            
            if is_negative or has_consumeable_space then
                e.config.colour = G.C.GREEN
                e.config.button = 'use_card'
            else
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = nil
            end
            return
        end
    end

    old_can_select_card(e)
end

local start_dissolve_original = Card.start_dissolve

function Card:start_dissolve(...)

    if self.config and self.config.center and self.config.center.set == "Joker" and self.config.center.key == 'j_abn_oopsy_daisy' then
		if self.area == G.consumeables and G.consumeables then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - self.ability.extra.slots
			for _, v in pairs(G.consumeables.cards) do
				if v.config.center.set == 'Joker' then
					v:shatter()
				end
			end
		end
    end

    -- Call original method
    return start_dissolve_original(self, ...)
end



SMODS.Joker {
  key = 'oopsy_daisy',
  rarity = 3,
  atlas = 'ABNJokerSheet21',
  pos = { x = 3, y = 5 },
  cost = 10,
  discovered = false,
  blueprint_compat = true,
  config = { extra = { slots = 4, } },
  
  loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.slots
        }
    }
  end,

  
  add_to_deck = function(self, card)
  
	G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots

    local copy = copy_card(card, nil, nil, nil, true)
    G.consumeables:emplace(copy)
    copy:start_materialize(nil, nil)
	  
	card:start_dissolve()
	  
  end,
  
  abn_artist_credits = {
    artist = "Mini Bit",
  },
}
