SMODS.Joker {
  key = 'jerry_jester',

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
    return { vars = { cae.x_mult, cae.x_mult_gain } }
  end,

  rarity = 4,
  atlas = 'AbandoniaLegendary',
  pos = { x = 2, y = 9 },
  soul_pos = { x = 3, y = 9 },
  cost = 10,
  discovered = false,
  blueprint_compat = true,
  unlocked = false,

  config = { extra = { x_mult = 1.5, x_mult_gain = 0.09, chips = 0 } },

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("abn_Leaf") then
      if next(SMODS.find_card("j_joker")) and #G.hand.cards > 0 then
        local max_leaf_chip = 0
        if context.scoring_hand then
          for _, sc in ipairs(context.scoring_hand) do
            if sc:is_suit("abn_Leaf") then
              local chip_val = (sc.base and sc.base.value and SMODS.Ranks[sc.base.value]) and SMODS.Ranks[sc.base.value].nominal or 0
              if chip_val > max_leaf_chip then
                max_leaf_chip = chip_val
              end
            end
          end
        end

        if max_leaf_chip > 0 then
          for _, held in ipairs(G.hand.cards) do
            held.ability.perma_chips = (held.ability.perma_chips or 0) + max_leaf_chip
            SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.CHIPS }, held)
          end
        end
      end

      if not context.blueprint then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "x_mult",
          scalar_value = "x_mult_gain",
        })
      end

      return {
        x_mult = card.ability.extra.x_mult,
        card = card,
        colour = G.C.MULT
      }
    end
  end,

  add_to_deck = function(self, card)
    unlock_card(self)
  end,

  abn_artist_credits = {
    artist = "Inky & RattlingSnow",
  },

  in_pool = function(self, args)
    for _, playing in ipairs(G.playing_cards or {}) do
      if playing:is_suit("abn_Leaf") then
        return true
      end
    end
  end
}