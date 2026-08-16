SMODS.Joker {
  key = 'bloke_joker',

  atlas = 'ABNJokerSheet20',
  pos = { x = 2, y = 5 },

  cost = 6,
  rarity = 2,

  abn_coder = "LasagnaFelidae",

  discovered = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,

  config = { extra = { repetitions = 2 } },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_teastain
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_teatag
    return {
      vars = {
        localize({ type = 'name_text', key = "m_abn_teastain", set = "Enhanced" }),
        localize({ type = 'name_text', key = "m_abn_teatag", set = "Enhanced" }),
        card.ability.extra.repetitions }
    }
  end,

  calculate = function(self, card, context)
    if context.repetition and context.other_card and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, "m_abn_teastain") or SMODS.has_enhancement(context.other_card, "m_abn_teatag") then
        return { repetitions = card.ability.extra.repetitions, card = context.other_card }
      end
    end
  end,
  in_pool = function(self, args)
    if not G.playing_cards then return false end
    for _, playing_card in ipairs(G.playing_cards) do
      if SMODS.has_enhancement(playing_card, "m_abn_teastain") or SMODS.has_enhancement(playing_card, "m_abn_teatag") then
        return true
      end
    end
    return false
  end,
  abn_artist_credits = { artist = "Mini Bit" },
}
