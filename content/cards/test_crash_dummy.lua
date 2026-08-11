SMODS.Joker {
  key = 'test_crash_dummy',
  rarity = 2,
  atlas = 'ABNJokerSheet20',
  pos = { x = 0, y = 3 },
  cost = 8,
  discovered = false,
  blueprint_compat = true,
  config = { extra = { chips = 0, triggered_this_round = false } },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_hazard
    return {
      vars = {
        card.ability.extra.chips
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      card.ability.extra.triggered_this_round = false
    end

    if context.before and not context.blueprint then
      if context.scoring_name == "Pair" and not card.ability.extra.triggered_this_round then
        card.ability.extra.triggered_this_round = true
        for _, scoring_card in ipairs(context.scoring_hand) do
          if scoring_card.config.center_key ~= 'm_abn_hazard' then
            scoring_card:set_ability(G.P_CENTERS.m_abn_hazard)
            scoring_card.ability.abn_newly_hazard_spared = true
            G.E_MANAGER:add_event(Event({
              func = function()
                scoring_card:juice_up()
                return true
              end
            }))
          end
        end
      end
    end

    if context.individual and context.cardarea == G.play then
      if context.other_card.config.center_key == 'm_abn_hazard' then
        if not context.other_card.ability.abn_newly_hazard_spared then
          context.other_card.ability.abn_marked_for_hazard_destroy = true
        end
      end
    end

    if context.destroying_card and context.cardarea == G.play and not (G.GAME.blind and G.GAME.blind.disabled) then
      if context.destroying_card.ability and context.destroying_card.ability.abn_marked_for_hazard_destroy then
        context.destroying_card.ability.abn_marked_for_hazard_destroy = nil

        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = "chips",
          scalar_table = context.destroying_card.base,
          scalar_value = "nominal",
          operation = '+',
        })

        return { remove = true }
      end
    end

    if context.destroying_card and context.destroying_card.ability and context.destroying_card.ability.abn_newly_hazard_spared then
      context.destroying_card.ability.abn_newly_hazard_spared = nil
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
  abn_artist_credits = {
    artist = "Rvol65",
  },
}