-- Worldwind Joker

SMODS.Joker {
  key = 'worldwind_joker',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.xmult } }
  end,

  rarity = 2,
  atlas = 'ABNJokerSheet9',
  pos = { x = 0, y = 2 },
  cost = 6,
  discovered = false,
  blueprint_compat = true,


  config = { extra = { xmult = 2 } },
  calculate = function(self, card, context)
    if context.before then
      if #G.jokers.cards > 1 then
        G.jokers:shuffle('aajk')
        play_sound('cardSlide1', 0.85)
        delay(0.15)
        G.jokers:shuffle('aajk')
        play_sound('cardSlide1', 1.15)
        delay(0.15)
        G.jokers:shuffle('aajk')
        play_sound('cardSlide1', 1)
        delay(0.5)
      end
    end
    if context.retrigger_joker_check and context.other_card and context.other_card == G.jokers.cards[1] and context.other_card ~= card then
      return {
        repetitions = 1,
        card = context.other_card,
        message = localize('k_again_ex')
      }
    end
    if context.joker_main and G.jokers.cards[1] == card then
      return {
        xmult = card.ability.extra.xmult
      }
    end
  end,
  abn_artist_credits = {
    artist = "Euphorix",
  },

}
