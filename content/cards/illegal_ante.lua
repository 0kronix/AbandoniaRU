local old_ease_dollars = ease_dollars
function ease_dollars(mod, instant)
  mod = mod or 0
  -- double gained dollars if joker exists and the ante is odd
  if mod > 0
  and next(SMODS.find_card("j_abn_illegal_ante"))
  and G.GAME.round_resets.blind_ante
  and G.GAME.round_resets.blind_ante % 2 == 1 then
    mod = mod * 2
  end

  old_ease_dollars(mod, instant)
end

SMODS.Joker {
  key = 'illegal_ante',
  rarity = 2,
  atlas = 'ABNJokerSheet11',
  pos = { x = 9, y = 4 },
  cost = 6,
  discovered = false,
  blueprint_compat = false,
  config = { extra = {} },

  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint and G.GAME.round_resets.ante % 2 == 0 then
      return {
        numerator = context.numerator * 2
      }
    end
  end,

  abn_artist_credits = {
    artist = "Notextify"
  },
}
