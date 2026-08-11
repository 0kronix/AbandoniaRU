SMODS.Joker {
  key = 'joker_tile',
  rarity = 2,
  atlas = 'ABNJokerSheet20',
  pos = { x = 3, y = 4 },
  cost = 6,
  discovered = false,
  blueprint_compat = true,
  config = { extra = { xchips = 1, xchipsadd = 0.2 } },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xchips,
		card.ability.extra.xchipsadd,
      }
    }
  end,
  
  calculate = function(self, card, context)

    if context.before and not context.blueprint then
      local joker_count = #G.jokers.cards
	  local scored_count = #context.scoring_hand
	  
	  if scored_count == joker_count then
		card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchipsadd
		return {
			message = localize('k_upgrade_ex'),
			colour = G.C.CHIPS,
			card = card,
		}
	  else
		if card.ability.extra.xchips > 1 then
			card.ability.extra.xchips = 1
			return {
				message = localize('k_reset'),
				card = card,
			}
		end
	  end
    end
    
    if context.joker_main then
      return {
        xchips = card.ability.extra.xchips
      }
    end
	
  end,
  abn_artist_credits = {
    artist = "pitissaria_2",
  },
}