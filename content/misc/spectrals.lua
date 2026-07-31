SMODS.Consumable {
  key = 'flipside',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 0, y = 0 },
  config = { max_highlighted = 3, },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { key = "abn_flipped_card", set = "Other" }
    return { vars = { card.ability.max_highlighted } }
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    for _, v in ipairs(G.hand.highlighted) do
      v:flip()
      v.ability.abn_perma_flipped = true
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        G.hand:unhighlight_all()
        return true
      end
    }))
    delay(0.5)
  end,
  abn_artist_credits = {
    artist = "lolhappy909_lol"
  },
}

SMODS.Consumable {
  key = 'abyss',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 1, y = 0 },
  config = { max_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_chthonian
    return { vars = { card.ability.max_highlighted, localize({ type = 'name_text', key = "e_abn_chthonian", set = "Edition" }) } }
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local aura_card = G.hand.highlighted[1]
        aura_card:set_edition("e_abn_chthonian", true)
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0 and
        (not G.hand.highlighted[1].edition)
  end,
  abn_artist_credits = {
    artist = "L'"
  },
}

SMODS.Consumable {
  key = 'body',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 5, y = 0 },
  soul_pos = { x = 6, y = 0 },
  hidden = true,
  soul_set = 'Tarot',
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({ set = 'Joker', rarity = "abn_SuperRare" })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    delay(0.6)
  end,
  can_use = function(self, card)
    return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
  end,
  abn_artist_credits = {
    artist = "ricottakitten"
  },
}


SMODS.Consumable {
  key = 'mind',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 4, y = 0 },
  soul_pos = { x = 7, y = 0 },
  hidden = true,
  soul_set = 'Tarot',
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({ set = 'Joker', rarity = "abn_ParallelRare" })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    delay(0.6)
  end,
  can_use = function(self, card)
    return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
  end,
  abn_artist_credits = {
    artist = "ricottakitten"
  },
}

local scu = set_consumeable_usage
function set_consumeable_usage(card)
  local ret = scu(card)
  if card.config.center.set == 'Spectral' and card.config.center.key ~= "c_soul" then
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            G.GAME.abn_last_spectral = card.config.center.key
            return true
          end
        }))
        return true
      end
    }))
  end
  return ret
end

SMODS.Consumable {
  key = 'deja_vecu',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 0, y = 1 },
  loc_vars = function(self, info_queue, card)
    local dejavecu_c = G.GAME.abn_last_spectral and G.P_CENTERS[G.GAME.abn_last_spectral] or nil
    local abn_last_spectral = dejavecu_c and
        localize { type = 'name_text', key = dejavecu_c.key, set = dejavecu_c.set } or
        localize('k_none')
    local colour = (not dejavecu_c or dejavecu_c.key == "c_abn_deja_vecu") and G.C.RED or G.C.GREEN

    if dejavecu_c and dejavecu_c.key ~= "c_abn_deja_vecu" then
      info_queue[#info_queue + 1] = dejavecu_c
    end

    local main_end = {
      {
        n = G.UIT.C,
        config = { align = "bm", padding = 0.02 },
        nodes = {
          {
            n = G.UIT.C,
            config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
            nodes = {
              { n = G.UIT.T, config = { text = ' ' .. abn_last_spectral .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
            }
          }
        }
      }
    }

    return { vars = { abn_last_spectral }, main_end = main_end }
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          SMODS.add_card({ key = G.GAME.abn_last_spectral })
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))
    delay(0.6)
  end,
  can_use = function(self, card)
    return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
        G.GAME.abn_last_spectral and
        G.GAME.abn_last_spectral ~= 'c_abn_deja_vecu'
  end,
  abn_artist_credits = {
    artist = "Vega"
  },
}

SMODS.Consumable {
  key = 'presque_vu',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 5, y = 1 },
  config = { extra = {}, max_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
    return { vars = { card.ability.max_highlighted } }
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local presque_vu_card = G.hand.highlighted[1]
        presque_vu_card:set_edition("e_negative", true)
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  abn_artist_credits = {
    artist = "Flote"
  },
}

SMODS.Consumable {
  key = 'chance',
  set = 'Spectral',
  atlas = "AbandoniaChance",
  pos = { x = 0, y = 0 },
  config = { extra = { odds = 16, e_conv = "e_negative" } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
    return {
      vars = {
        numerator, denominator,
      }
    }
  end,
  can_use = function(self, card)
    return G.jokers and G.jokers.cards and #G.jokers.cards >= 1
  end,
  use = function(self, card, area, copier)
    if SMODS.pseudorandom_probability(card, "c_abn_chance", 1, card.ability.extra.odds) then
      for i = 1, #G.jokers.cards do
        local current = G.jokers.cards[i]
        current:set_edition(card.ability.extra.e_conv)
      end
    else
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          attention_text({
            text = localize('k_nope_ex'),
            scale = 1.3,
            hold = 1.4,
            major = card,
            backdrop_colour = G.C.SECONDARY_SET.Tarot,
            align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                'tm' or 'cm',
            offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
            silent = true
          })
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.06 * G.SETTINGS.GAMESPEED,
            blockable = false,
            blocking = false,
            func = function()
              play_sound('tarot2', 0.76, 0.4)
              return true
            end
          }))
          play_sound('tarot2', 1, 0.4)
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
    end
  end,

  abn_artist_credits = {
    artist = "Shepcicle"
  },
}

SMODS.Consumable {
  key = 'distortion',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 6, y = 3 },
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_pearlescent
    return { vars = {} }
  end,
  use = function(self, card, area, copier)
    local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local eligible_card = pseudorandom_element(editionless_jokers, 'vremade_hex')
        eligible_card:set_edition("e_abn_pearlescent")

        local _first_dissolve = nil
        for _, joker in ipairs(G.jokers.cards) do
          if joker ~= eligible_card and not SMODS.is_eternal(joker, card) then
            joker:start_dissolve(nil, _first_dissolve)
            _first_dissolve = true
          end
        end

        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  can_use = function(self, card)
    return next(SMODS.Edition:get_edition_cards(G.jokers, true))
  end,
  abn_artist_credits = {
    artist = "Flote"
  },
}

SMODS.Consumable {
  key = 'super_id',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 6, y = 1 },
  config = { extra = {}, max_highlighted = 1 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_pearlescent
    info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_gloss
    info_queue[#info_queue + 1] = G.P_CENTERS.e_abn_iridescent
    return { vars = { card.ability.max_highlighted } }
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.highlighted == card.ability.max_highlighted and (not G.hand.highlighted[1].edition)
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local choices = { 'abn_gloss', 'abn_iridescent', 'abn_pearlescent' }

        local chosen_edition = pseudorandom_element(choices, 'abn_ascend')

        local ascend_card = G.hand.highlighted[1]

        ascend_card:set_edition({ [chosen_edition] = true }, true)

        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  abn_artist_credits = {
    artist = "Da Gorbage Rat"
  },
}

SMODS.Consumable {
  key = 'whitehole',
  set = 'Spectral',
  atlas = "AbandoniaSpectrals",
  pos = { x = 5, y = 3 },
  hidden = true,
  soul_set = 'Planet',

  use = function(self, card, area, copier)
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
      { handname = "All Ranks", chips = '...', mult = '...', level = '' })
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = true
        return true
      end
    }))
    update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.9,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        return true
      end
    }))
    update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.9,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = nil
        return true
      end
    }))
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+1' })
    delay(1.3)
    for rank, _ in pairs(SMODS.Ranks) do
      if G.GAME.abn_rank_upgrades[rank] then
        ABN.level_up_rank(card, rank, 1, true)
      end
    end
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
      { mult = 0, chips = 0, handname = '', level = '' })
  end,
  can_use = function(self, card)
    return true
  end,
  abn_artist_credits = {
    artist = "shepcicle"
  },
}
