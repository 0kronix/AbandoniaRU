SMODS.Enhancement({
  key = "plank",
  pos = { x = 5, y = 4 },
  atlas = "AbandoniaEnhancements",
  replace_base_card = false,
  no_rank = false,
  no_suit = false,
  always_scores = false,
  config = { extra = { ascension = 0.25 } },
  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.ascension } }
  end,

  calculate = function(self, card, context)
    local cae = card.ability.extra
    if context.main_scoring and context.cardarea == G.play then
      return {
        asc = cae.ascension,
      }
    end
  end,

  abn_artist_credits = {
    artist = "Super Thing",
  },
})

SMODS.Joker {
  key = 'plank_joker',
  rarity = 1,
  cost = 6,
  atlas = 'ABNJokerSheet21',
  pos = { x = 0, y = 0 },
  discovered = false,
  blueprint_compat = true,
  config = {
    extra = {
      asc_mod = 0.03
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_plank
    return {
      vars = {
        card.ability.extra.asc_mod
      }
    }
  end,

  in_pool = function(self)
    if not G.playing_cards then return false end

    for _, card in ipairs(G.playing_cards) do
      if card and card.config and card.config.center then
        if card.config.center == G.P_CENTERS.m_abn_plank then
          return true
        end
      end
    end
    return false
  end,

  calculate = function(self, card, context)
    if context.before and context.scoring_hand then
      for _, scoring_card in ipairs(context.scoring_hand) do
        if scoring_card.config.center == G.P_CENTERS.m_abn_plank then
          if scoring_card.ability and scoring_card.ability.extra and scoring_card.ability.extra.ascension then
            scoring_card.ability.extra.ascension = scoring_card.ability.extra.ascension + card.ability.extra.asc_mod

            card_eval_status_text(scoring_card, 'extra', nil, nil, nil, {
              message = localize('k_upgrade_ex'),
              colour = G.C.GOLD
            })
          end
        end
      end
    end
  end,

  abn_artist_credits = {
    artist = "Super Thing",
  },
}

SMODS.Joker {
  key = 'bark_joker',
  rarity = 2,
  cost = 8,
  atlas = 'ABNJokerSheet3',
  pos = { x = 6, y = 3 },
  discovered = false,
  blueprint_compat = true,
  config = {
    extra = {
      xmult = 1,
      xmultadd = 0.1,
      ascension = 0,
      asc_mod = 0.03
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_plank
    return {
      vars = {
        card.ability.extra.xmult,
        card.ability.extra.xmultadd,
        card.ability.extra.ascension,
        card.ability.extra.asc_mod
      }
    }
  end,

  in_pool = function(self, args)
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        if c.config.center == G.P_CENTERS.m_abn_plank then
          return true
        end
      end
    end
    return false
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card.config.center == G.P_CENTERS.m_abn_plank then
        if not context.blueprint then
          card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultadd
          card.ability.extra.ascension = card.ability.extra.ascension + card.ability.extra.asc_mod
        end

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.GOLD,
          card = card
        }
      end
    end

    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult,
        asc = card.ability.extra.ascension
      }
    end
  end,

  abn_artist_credits = {
    artist = "Sustato",
  },
}

SMODS.Joker {
  key = 'old_growth_joker',
  rarity = 3,
  cost = 10,
  atlas = 'ABNJokerSheet5',
  pos = { x = 4, y = 1 },
  discovered = false,
  blueprint_compat = true,
  config = {
    extra = {
      mult = 0,
      ascension = 0,
      asc_mod = 0.03
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_plank
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.ascension,
        card.ability.extra.asc_mod
      }
    }
  end,

  in_pool = function(self, args)
    if G.playing_cards then
      for _, c in ipairs(G.playing_cards) do
        if c.config.center == G.P_CENTERS.m_abn_plank then
          return true
        end
      end
    end
    return false
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local other = context.other_card
      if other and other.config.center == G.P_CENTERS.m_abn_plank and ABN.is_number(other) then
        if not context.blueprint then
          local nominal_val = other.base and other.base.nominal or 0
          local gained_mult = nominal_val * 3

          card.ability.extra.mult = card.ability.extra.mult + gained_mult
          card.ability.extra.ascension = card.ability.extra.ascension + card.ability.extra.asc_mod
        end

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.GOLD,
          card = card
        }
      end
    end


    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
        asc = card.ability.extra.ascension
      }
    end
  end,

  abn_artist_credits = {
    artist = "D.J.",
  },
}

SMODS.Joker {
  key = 'plug_in_joker',
  rarity = 1,
  cost = 6,
  atlas = 'ABNJokerSheet21',
  pos = { x = 8, y = 3 },
  discovered = false,
  blueprint_compat = true,
  config = {
    extra = {
      mult = 0,
      chips = 0,
      ascension = 0,
      multadd = 4,
      chipsadd = 10,
      asc_mod = 0.25
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue + 1] = G.P_CENTERS.m_abn_plank
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.chips,
        card.ability.extra.ascension,
        card.ability.extra.multadd,
        card.ability.extra.chipsadd,
        card.ability.extra.asc_mod
      }
    }
  end,

  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local other = context.other_card
      if other then
        local center = other.config.center
        local upgraded = false
        local msg_col = G.C.FILTER

        if center == G.P_CENTERS.m_mult then
          if not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multadd
          end
          upgraded = true
          msg_col = G.C.MULT
        elseif center == G.P_CENTERS.m_bonus then
          if not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsadd
          end
          upgraded = true
          msg_col = G.C.CHIPS
        elseif center == G.P_CENTERS.m_abn_plank then
          if not context.blueprint then
            card.ability.extra.ascension = card.ability.extra.ascension + card.ability.extra.asc_mod
          end
          upgraded = true
          msg_col = G.C.GOLD
        end

        if upgraded then
          return {
            message = localize('k_upgrade_ex'),
            colour = msg_col,
            card = card
          }
        end
      end
    end

    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
        chips = card.ability.extra.chips,
        asc = card.ability.extra.ascension
      }
    end
  end,

  abn_artist_credits = {
    artist = "0kronix",
  },
}

ABN.CalligraphyCard {
  key = "u_cal",
  pos = { x = 2, y = 3 },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.mod_conv]
    return {
      vars = {
        localize(card.ability.extra.suit_conv, 'suits_plural'),
        colours = { G.C.SUITS[card.ability.extra.suit_conv] }
      }
    }
  end,

  config = { extra = { suit_conv = "abn_Star", mod_conv = "m_abn_plank" } },

  can_use = function(self, card)
    return G.hand and #G.hand.cards > 0 and G.GAME.blind and not G.GAME.blind.in_blind
  end,

  use = function(self, card, area, copier)
    local leftmost = G.hand.cards[1]
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.15,
      func = function()
        leftmost:flip()
        play_sound('card1', 1)
        leftmost:juice_up(0.3, 0.3)
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.change_base(leftmost, card.ability.extra.suit_conv, leftmost.base.value)
        leftmost:set_ability(G.P_CENTERS[card.ability.extra.mod_conv])
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.15,
      func = function()
        leftmost:flip()
        play_sound('tarot2', 1, 0.6)
        leftmost:juice_up(0.3, 0.3)
        return true
      end
    }))
    delay(0.5)
  end,
}