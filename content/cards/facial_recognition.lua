SMODS.Joker {
  key = 'facial_recognition',
  rarity = 3,
  atlas = 'ABNJokerSheet21',
  pos = { x = 7, y = 4 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,
  config = { 
    extra = { 
      xmult = 1,
      xmultadd = 1,
      chips = 0
    } 
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmultadd,
        card.ability.extra.xmult,
        card.ability.extra.chips
      }
    }
  end,

  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint and card.facing ~= 'back' then
      local unique_ranks = {}
      local count = 0

      for _, scoring_card in ipairs(context.scoring_hand) do
        if (scoring_card.facing == 'back' or scoring_card.ability.abn_perma_flipped) and not scoring_card.debuffed then
          local rank = scoring_card:get_id()
          if rank and rank > 0 and not unique_ranks[rank] then
            unique_ranks[rank] = true
            count = count + 1
          end
        end
      end

      if count > 0 then
        card.ability.extra.xmult = card.ability.extra.xmult + (count * card.ability.extra.xmultadd)
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end

    if context.individual and context.cardarea == G.play then
      local is_joker_flipped = (card.facing == 'back' or card.ability.abn_perma_flipped)
      local is_card_flipped = (context.other_card.facing == 'back' or context.other_card.ability.abn_perma_flipped)

      if is_joker_flipped and is_card_flipped then
        local rank_val = context.other_card.base.nominal
        if rank_val and rank_val > 0 then


          card.ability.extra.chips = card.ability.extra.chips + rank_val

          return {
            message = localize('k_upgrade_ex'),
			colour = G.C.CHIPS,
			card = card,
          }
        end
      end
    end


    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult,
        chips = card.ability.extra.chips,
      }
    end
  end,
  
  abn_artist_credits = {
    artist = "0kronix",
  },
}