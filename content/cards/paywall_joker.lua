SMODS.Joker {
    key = 'paywall_joker',

    rarity = 2,
    atlas = 'ABNJokerSheet19',
    pos = { x = 7, y = 3 },
    cost = 8,
    discovered = false,
    blueprint_compat = true,

    config = { extra = { target_id = nil, triggered_this_hand = false } },

    abn_artist_credits = {
        artist = "Weasel.922"
    },
	
	update = function(self, card)
        if card.area == G.jokers and G.GAME.dollars <= 0 then
            card:start_dissolve()
        end
    end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.triggered_this_hand = false
            
            local eligible_jokers = {}
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card then
                    table.insert(eligible_jokers, j)
                end
            end

            if #eligible_jokers > 0 then
                local chosen = pseudorandom_element(eligible_jokers, pseudoseed('paywall_joker'))
                card.ability.extra.target_id = chosen.unique_val or chosen.ID
            else
                card.ability.extra.target_id = nil
            end
        end

        if context.retrigger_joker_check and not context.retrigger_joker then
            if not card.ability.extra.triggered_this_hand and card.ability.extra.target_id then
                local target = context.other_joker or context.other_card
                local target_id = target and (target.unique_val or target.ID)

                if target_id and target_id == card.ability.extra.target_id then
                    card.ability.extra.triggered_this_hand = true

                    local cost_to_pay = target.sell_cost or 0
                    if cost_to_pay > 0 then
                        ease_dollars(-cost_to_pay)
                    end

                    return {
                        message = localize('k_again_ex'),
                        repetitions = 1,
                        card = card
                    }
                end
            end
        end

        if context.after then
            card.ability.extra.target_id = nil
            card.ability.extra.triggered_this_hand = false
        end
    end
}