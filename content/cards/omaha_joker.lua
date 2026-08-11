-- Omaha Joker

SMODS.Joker {
  key = 'omaha_joker',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.mult, cae.mult_gain } }
  end,

  rarity = 3,
  atlas = 'ABNJokerSheet15',
  pos = { x = 9, y = 2 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,


  config = { extra = { mult = 0, mult_gain = 1 } },
  calculate = function(self, card, context)
    if context.before and context.poker_hands and #context.scoring_hand == 5 then
      local cph = {}
      for k, v in pairs(context.poker_hands) do
        if next(v) then
          cph[k] = true
        end
      end

      local count = 0
      for k, v in pairs(cph) do
        count = count + 1
      end

      if count > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "mult",
          scalar_value = "mult_gain",
          message_colour = G.C.MULT,
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + count * change
          end,
        })
      end
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  abn_artist_credits = {
    artist = "IPreferCheddar",
  },

}
