-- Jenga Joker
SMODS.Joker {
  key = 'jenga_joker',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.x_mult, cae.x_mult_gain, } }
  end,

  rarity = 2,
  atlas = 'ABNJokerSheet20',
  pos = { x = 7, y = 3 },
  cost = 6,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { x_mult = 1, x_mult_gain = 0.3 } },
  calculate = function(self, card, context)
    if context.after and not context.blueprint and SMODS.calculate_round_score() >= (G.GAME.blind.chips * 2) then
      SMODS.destroy_cards(card)
      SMODS.calculate_effect({ message = localize('k_abn_destroyed'), colour = G.C.RED }, card)
    end

    if context.joker_type_destroyed and context.card == card and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          local new_card = SMODS.add_card {
            key = 'j_abn_jenga_joker',
          }
          copy_card(card, new_card)
          SMODS.scale_card(new_card, {
            ref_table = new_card.ability.extra,
            ref_value = 'x_mult',
            scalar_table = card.ability.extra,
            scalar_value = 'x_mult_gain',
            message_colour = G.C.MULT,
            message_key = 'a_xmult'
          })
          return true;
        end
      }))
    end

    if context.joker_main then
      return {
        x_mult = card.ability.extra.x_mult
      }
    end
  end,
  abn_artist_credits = {
    artist = "0kronix",
  },

}
