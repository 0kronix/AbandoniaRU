-- Cloud Screamer
SMODS.Joker {
  key = 'cloud_screamer',

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,

  rarity = 2,
  atlas = 'ABNJokerSheet18',
  pos = { x = 0, y = 1 },
  pixel_size = { w = 71, h = 64 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { mult = 9 } },
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.scoring_hand and context.other_card == context.scoring_hand[1] then
        context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra
            .mult
        return {
          message = localize("k_upgrade_ex"),
          message_card = context.other_card,
          colour = G.C.MULT
        }
      end
    end
  end,
  abn_artist_credits = {
    artist = "b.b.b.b",
  },
}
