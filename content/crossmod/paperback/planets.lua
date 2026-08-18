SMODS.Consumable {
  key = "coissa",
  set = "Planet",
  cost = 4,
  atlas = "AbandoniaPlanets",
  pos = { x = 4, y = 6 },
  config = { hand_type = "abn_Rapture", softlock = true },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        G.GAME.hands[card.ability.hand_type].level,
        localize(card.ability.hand_type, 'poker_hands'),
        G.GAME.hands[card.ability.hand_type].l_mult,
        G.GAME.hands[card.ability.hand_type].l_chips,
        colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
      }
    }
  end,
  abn_artist_credits = {
    artist = "0kronix"
  },
  dependencies = {
    "paperback"
  },
}

SMODS.Consumable {
  key = "proxima_b",
  set = "Planet",
  cost = 4,
  atlas = "AbandoniaPlanets",
  pos = { x = 0, y = 7 },
  config = { hand_type = "abn_Inverse Rapture", softlock = true },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        G.GAME.hands[card.ability.hand_type].level,
        localize(card.ability.hand_type, 'poker_hands'),
        G.GAME.hands[card.ability.hand_type].l_mult,
        G.GAME.hands[card.ability.hand_type].l_chips,
        colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
      }
    }
  end,
  abn_artist_credits = {
    artist = "0kronix"
  },
  dependencies = {
    "paperback"
  },
}

SMODS.Consumable {
  key = "proxima_c",
  set = "Planet",
  cost = 4,
  atlas = "AbandoniaPlanets",
  pos = { x = 5, y = 6 },
  config = { hand_type = "abn_Rapture Spectrum", softlock = true },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        G.GAME.hands[card.ability.hand_type].level,
        localize(card.ability.hand_type, 'poker_hands'),
        G.GAME.hands[card.ability.hand_type].l_mult,
        G.GAME.hands[card.ability.hand_type].l_chips,
        colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
      }
    }
  end,
  abn_artist_credits = {
    artist = "0kronix"
  },
  dependencies = {
    "paperback"
  },
}
