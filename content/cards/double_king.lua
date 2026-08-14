SMODS.Joker {
  key = 'double_king',
  rarity = 2,
  atlas = 'ABNJokerSheet20',
  pos = { x = 6, y = 2 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,
  config = { extra = { chips = 0, mult = 2 } },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chips,
        card.ability.extra.mult,
      }
    }
  end,

  calculate = function(self, card, context)
    if context.destroying_card and context.destroying_card:get_id() == 13 and not context.blueprint then
      if context.cardarea == G.play or context.cardarea == "unscored" then
        local chips_gain = context.destroying_card.base.nominal * 2
        card.ability.extra.chips = card.ability.extra.chips + chips_gain

        return {
          remove = true,
		  message = localize('k_upgrade_ex'),
		  colour = G.C.CHIPS,
        }
      end
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end

    if context.individual and context.cardarea == G.play then
      local card_id = context.other_card:get_id()
      local ret = {}

      local negative_mr_bones_count = 0
      if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
          if j.config.center.key == 'j_mr_bones' and j.edition and j.edition.negative then
            negative_mr_bones_count = negative_mr_bones_count + 1
          end
        end
      end

      if card_id == 13 then
        ret.chips = context.other_card.base.nominal * -1
        ret.card = card
      end

      if negative_mr_bones_count > 0 then
        ret.mult = card.ability.extra.mult * negative_mr_bones_count
        ret.card = card
      end

      if ret.chips or ret.mult then
        return ret
      end
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
      if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
          local has_negative = j.edition and j.edition.negative
          if j.config.center.key == 'j_mr_bones' and not has_negative then
            j:set_edition({ negative = true }, true)
          end
        end
      end
    end
  end,

  abn_artist_credits = {
    artist = "pitissaria_2",
  },
}