SMODS.Joker {
  key = 'zack_comic',

  loc_txt = {
    ['en-us'] = {
      unlock = {
        "?????",
      },
    }
  },
  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    info_queue[#info_queue + 1] = G.P_CENTERS.j_joker
    return { vars = { cae.x_chips, cae.x_chips_gain } }
  end,

  rarity = 4,
  atlas = 'AbandoniaLegendary',
  pos = { x = 8, y = 13 },
  soul_pos = { x = 9, y = 13 },
  cost = 10,
  discovered = false,
  blueprint_compat = true,
  unlocked = false,

  config = { extra = { x_chips = 1.5, x_chips_gain = 0.09 } },

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("abn_Leaf") then
      if next(SMODS.find_card("j_joker")) and context.scoring_hand then
        local consumable_count = (G.consumeables and G.consumeables.cards) and #G.consumeables.cards or 0
        if consumable_count > 0 then
          for _, sc in ipairs(context.scoring_hand) do
            sc.ability.perma_mult = (sc.ability.perma_mult or 0) + consumable_count
            SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.MULT }, sc)
          end
        end
      end

      if not context.blueprint then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "x_chips",
          scalar_value = "x_chips_gain",
        })
      end

      return {
        xchips = card.ability.extra.x_chips,
        card = card,
        colour = G.C.CHIPS
      }
    end
  end,

  add_to_deck = function(self, card)
    unlock_card(self)
  end,

  abn_artist_credits = {
    artist = "Da Gorbage Rat & Zeze Is You",
  },

  in_pool = function(self, args)
    for _, playing in ipairs(G.playing_cards or {}) do
      if playing:is_suit("abn_Leaf") then
        return true
      end
    end
  end
}