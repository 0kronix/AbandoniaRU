-- Random Encounter
SMODS.Joker {
  key = 'random_encounter',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.mult, cae.mult_gain, } }
  end,

  rarity = 1,
  atlas = 'ABNJokerSheet21',
  pos = { x = 7, y = 3 },
  cost = 4,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { mult = 1, mult_gain = 1 } },
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.active = true
    end
    if context.after then
      card.ability.extra.active = false
    end
    if card.ability.extra.active and context.post_trigger and context.other_card and context.other_card.config and context.other_card.config.center_key ~= "j_abn_force_encounter" and not context.blueprint_card then
      if context.other_ret and context.other_ret.jokers and
          (type(context.other_ret.jokers) == "table" and context.other_ret.jokers.chips and context.other_ret.jokers.chips ~= 0)
          or (type(context.other_ret.jokers) == "table" and context.other_ret.jokers.chip_mod and context.other_ret.jokers.chip_mod ~= 0) then
        return {
          func = function()
            SMODS.calculate_effect {
              card = card,
              mult = card.ability.extra.mult
            }
            return true
          end
        }
      end
    end
    if context.end_of_round and context.main_eval and not context.blueprint then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "mult",
        scalar_value = "mult_gain",
        operation = '+',
        message_colour = G.C.MULT
      })
    end
  end,
  abn_artist_credits = {
    artist = "0kronix",
  },

}
