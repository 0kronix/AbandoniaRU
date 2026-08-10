-- Aviator
SMODS.Joker {
  key = 'aviator',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.x_mult, cae.x_mult_gain, cae.level } }
  end,

  rarity = 2,
  atlas = 'ABNJokerSheet20',
  pos = { x = 0, y = 4 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { level = 2, x_mult = 1, x_mult_gain = 0.1 } },
  calculate = function(self, card, context)
    if context.before and not context.blueprint and G.GAME.hands[context.scoring_name].level >= card.ability.extra.level then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'x_mult',
        scalar_table = card.ability.extra,
        scalar_value = 'x_mult_gain',
        message_colour = G.C.MULT,
        message_key = 'a_xmult'
      })
    end
    if context.joker_main then
      return {
        x_mult = card.ability.extra.x_mult
      }
    end
  end,
  abn_artist_credits = {
    artist = "Mini Bit",
  },

}
