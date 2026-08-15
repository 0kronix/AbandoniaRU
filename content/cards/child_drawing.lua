-- Child Drawing
SMODS.Joker {
  key = 'child_drawing',

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.xmult } }
  end,

  rarity = 1,
  atlas = 'ABNJokerSheet18',
  pos = { x = 4, y = 4 },
  cost = 4,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { xmult = 1.3 } },
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if ABN.is_number(context.other_card) then
        return {
          xmult = card.ability.extra.xmult
        }
      end
    end
  end,
  abn_artist_credits = {
    artist = "b.b.b.b",
  },
}
