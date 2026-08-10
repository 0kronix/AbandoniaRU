SMODS.Joker {
  key = 'yharman_joker',

  loc_vars = function(self, info_queue, card)
    local chosen_suit_text = "Light"
    local chosen_suit_colour = G.C.SUITS["Diamonds"]
    local chosen_suit_edition = localize({ type = 'name_text', key = "e_abn_bright", set = "Edition" })
    if card.ability.extra.chosen_suit == 'dark' then
      info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_opaque
      chosen_suit_text = "Dark"
      chosen_suit_colour = G.C.SUITS["Spades"]
      chosen_suit_edition = localize({ type = 'name_text', key = "e_abn_opaque", set = "Edition" })
    elseif card.ability.extra.chosen_suit == 'light' then
      info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_bright
      chosen_suit_text = "Light"
      chosen_suit_colour = G.C.SUITS["Diamonds"]
      chosen_suit_edition = localize({ type = 'name_text', key = "e_abn_bright", set = "Edition" })
    end
    return { vars = { chosen_suit_text, chosen_suit_edition, colours = { chosen_suit_colour } } }
  end,

  rarity = 3,
  atlas = 'ABNJokerSheet2',
  pos = { x = 5, y = 1 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { chosen_suit = 'light' } },

  calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
      if card.ability.extra.chosen_suit == 'dark' then
        card.ability.extra.chosen_suit = 'light'
      elseif card.ability.extra.chosen_suit == 'light' then
        card.ability.extra.chosen_suit = 'dark'
      end

      local chosen = card.ability.extra.chosen_suit

      for _, c in ipairs(G.playing_cards) do
        local matches_chosen = (chosen == 'dark' and ABN.is_dark(c)) or (chosen == 'light' and ABN.is_light(c))

        if matches_chosen then
          if c.facing == 'front' then
            c:flip()
          end
          c.ability.abn_perma_flipped = true
        else
          c.ability.abn_perma_flipped = false
          if c.facing == 'back' then
            c:flip()
          end
        end
      end
    end

    if context.cardarea == G.jokers and context.before then
      local has_front = false
      local back_count = 0
      for _, c in ipairs(context.scoring_hand) do
        if c.facing == 'front' then
          has_front = true
        elseif c.facing == 'back' then
          back_count = back_count + 1
        end
      end

      if has_front and back_count > 0 then
        for _, c in ipairs(context.scoring_hand) do
          if c.facing == 'front' then
            local card_rank = c.base.value
            if card_rank and G.GAME.abn_rank_upgrades[card_rank] then
              -- Level up the rank first
              ABN.level_up_rank(card, card_rank, back_count)

              -- Fetch the correct rank upgrade data from the global game object
              local current_rank_data = G.GAME.abn_rank_upgrades[card_rank]

              -- If the rank level is now above 5, apply the corresponding custom edition
              if current_rank_data and current_rank_data.level and current_rank_data.level > 5 then
                if ABN.is_light(c) then
                  c:set_edition({ abn_bright = true }, true)
                elseif ABN.is_dark(c) then
                  c:set_edition({ abn_opaque = true }, true)
                end
              end
            end
          end
        end
      end
    end
  end,

  abn_artist_credits = {
    artist = "that_devil_brony"
  },
}
