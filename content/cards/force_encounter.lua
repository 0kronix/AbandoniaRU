-- Forced Encounter
SMODS.Joker {
  key = 'force_encounter',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.chips, cae.chips_gain, } }
  end,

  rarity = 1,
  atlas = 'ABNJokerSheet21',
  pos = { x = 6, y = 3 },
  cost = 4,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { chips = 2, chips_gain = 1 } },
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.active = true
    end
    if context.after then
      card.ability.extra.active = false
    end
    if card.ability.extra.active and context.post_trigger and context.other_card and context.other_card.config and context.other_card.config.center_key ~= "j_abn_force_encounter" and not context.blueprint_card then
      if context.other_ret and context.other_ret.jokers and (type(context.other_ret.jokers) == "table" and context.other_ret.jokers.mult and context.other_ret.jokers.mult ~= 0)
          or (type(context.other_ret.jokers) == "table" and context.other_ret.jokers.mult_mod and context.other_ret.jokers.mult_mod ~= 0) then
        return {
          func = function()
            SMODS.calculate_effect {
              card = card,
              chips = card.ability.extra.chips
            }
            return true
          end
        }
      end
    end
    if context.end_of_round and context.main_eval and not context.blueprint then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "chips",
        scalar_value = "chips_gain",
        operation = '+',
        message_colour = G.C.CHIPS
      })
    end
  end,
  abn_artist_credits = {
    artist = "0kronix",
  },

}
