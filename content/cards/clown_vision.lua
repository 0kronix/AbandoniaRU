-- Clown Vision (coded by cloudzXIII)
SMODS.Joker {
  key = 'clown_vision',

  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    local numerator, denominator = SMODS.get_probability_vars(card, cae.base, cae.odds)

    return {
      vars = {
        cae.mult, cae.mult_gain,
        cae.p_gain, localize(cae.type, 'poker_hands'),
        cae.chips,
        numerator, denominator
      }
    }
  end,

  rarity = 2,
  atlas = 'ABNJokerSheet19',
  pos = { x = 5, y = 0 },
  cost = 6,
  discovered = false,
  blueprint_compat = true,

  config = { extra = { mult = 0, mult_gain = 6, type = "abn_Spectrum", p_gain = 1, chips = 5, base = 1, odds = 8 } },
  calculate = function(self, card, context)
    if context.before and next(context.poker_hands[card.ability.extra.type]) then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = "mult",
        scalar_value = "mult_gain",
        operation = '+',
      })

      if card.edition then
        local contains_chalices = false
        for i, v in ipairs(context.scoring_hand) do
          if v:is_suit("abn_Chalice") then
            contains_chalices = true
            break
          end
        end

        local contains_coins = false
        for i, v in ipairs(context.scoring_hand) do
          if v:is_suit("abn_Coin") then
            contains_coins = true
            break
          end
        end

        local contains_batons = false
        for i, v in ipairs(context.scoring_hand) do
          if v:is_suit("abn_Baton") then
            contains_batons = true
            break
          end
        end

        local contains_swords = false
        for i, v in ipairs(context.scoring_hand) do
          if v:is_suit("abn_Sword") then
            contains_swords = true
            break
          end
        end

        if contains_chalices then
          card:juice_up()
          for _, joker in ipairs(G.jokers.cards) do
            joker.ability.abn_perma_mult = (joker.ability.abn_perma_mult or 0) + card.ability.extra.p_gain
            SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.MULT }, joker)
          end
        end
        if contains_coins then
          card:juice_up()
          for _, other_card in ipairs(G.jokers.cards) do
            if other_card.set_cost then
              other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                  card.ability.extra.p_gain
              other_card:set_cost()
            end
          end
          SMODS.calculate_effect({ message = localize('k_val_up'), colour = G.C.MONEY }, card)
        end
        if contains_batons then
          card:juice_up()
          if SMODS.pseudorandom_probability(card, 'abn_clown_vision', card.ability.extra.base, card.ability.extra.odds) then
            SMODS.add_card { set = "Consumeables" }
          end
        end
        if contains_swords then
          card:juice_up()
          for _, joker in ipairs(G.jokers.cards) do
            joker.ability.abn_perma_bonus = (joker.ability.abn_perma_bonus or 0) + card.ability.extra.chips
            SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.CHIPS }, joker)
          end
        end
      end
    end

    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  abn_artist_credits = {
    artist = "Dogg-Fly",
  },
}
