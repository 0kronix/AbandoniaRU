-- i didnt have any idea on how to approach this Joker so if anyone decides to redo it at some point please also let me know on how you're going to do it (im revo)

SMODS.Joker({
	key = "napping_joker",
	rarity = 3,
	atlas = "ABNJokerSheet22",
	pos = { x = 7, y = 0 },
	cost = 10,
	discovered = false,
	blueprint_compat = false,
	config = {
		extra = {
			percentage = 50,
            added = {
                hand = {},
                rank = {}
            },
            used_planets = 0

		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.percentage, card.ability.extra.used_planets
			},
		}
	end,

    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.hands) do
            v.l_chips = v.l_chips-card.ability.extra.added.hand[k]
        end
         for k, v in pairs(G.GAME.abn_rank_upgrades) do
            v.l_chips = v.l_chips-card.ability.extra.added.rank[k]
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.hands) do
            card.ability.extra.added.hand[k] = (v.l_chips+(v.l_chips*(card.ability.extra.percentage/100))) - v.l_chips
            v.l_chips = v.l_chips+(v.l_chips*(card.ability.extra.percentage/100))
        end

        for k, v in pairs(G.GAME.abn_rank_upgrades) do
            card.ability.extra.added.rank[k] = (v.l_chips+(v.l_chips*(card.ability.extra.percentage/100))) - v.l_chips
            v.l_chips = v.l_chips+(v.l_chips*(card.ability.extra.percentage/100))
        end
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Planet" then
            card.ability.extra.used_planets = card.ability.extra.used_planets + 1
            ABN.msg(card, "+1")

            if card.ability.extra.used_planets >= 9 then
                G.E_MANAGER:add_event(Event{
                    func = function()
                        card:flip()
                        return true
                    end
                })
                 G.E_MANAGER:add_event(Event{
                    func = function()
                        card:set_ability("j_abn_snoozing_joker")
                        return true
                    end
                })
                 G.E_MANAGER:add_event(Event{
                    func = function()
                        card:flip()
                        return true
                    end
                })
            end
        end
    end,

	abn_artist_credits = {
		artist = "Pitissaria 2",
	},
})
