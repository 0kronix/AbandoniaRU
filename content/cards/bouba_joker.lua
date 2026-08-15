SMODS.Joker {
  key = 'bouba_joker',
  rarity = 1,
  cost = 6,
  atlas = 'ABNJokerSheet20',
  pos = { x = 5, y = 4 },
  discovered = false,
  blueprint_compat = true,
  config = {
    extra = {
      chips = 0,
      chipsadd = 2,
      scale_mod = 2
    }
  },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chips,
        card.ability.extra.chipsadd,
        card.ability.extra.scale_mod
      }
    }
  end,

  calculate = function(self, card, context)
    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
      if G.GAME.blind and G.GAME.blind.boss then
        local lexica_count = 0
        if G.consumeables and G.consumeables.cards then
          for _, c in ipairs(G.consumeables.cards) do
            if c.ability and c.ability.set == "lexica" then
              lexica_count = lexica_count + 1
            end
          end
        end

        if lexica_count > 0 then
          local total_increase = lexica_count * card.ability.extra.scale_mod
          card.ability.extra.chipsadd = card.ability.extra.chipsadd + total_increase

          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.CHIPS
          }
        end
      end
    end

    if context.individual and context.cardarea == G.play then
      local other = context.other_card
      if other and ABN.is_odd(other) then
        if not context.blueprint then
          card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsadd
        end

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS,
          card = card
        }
      end
    end

    if context.joker_main then
		return {
          chips = card.ability.extra.chips
        }
    end
  end,

  abn_artist_credits = {
    artist = "Gfs",
  },
}