-- i didnt have any idea on how to approach this Joker so if anyone decides to redo it at some point please also let me know on how you're going to do it (im revo)

SMODS.Joker({
	key = "snoozing_joker",
	rarity = 3,
	atlas = "ABNJokerSheet22",
	pos = { x = 8, y = 0 },
	cost = 10,
	discovered = false,
	blueprint_compat = false,
	config = {
		extra = {
			percentage = 30,
            added = {
				hand = {},
				rank = {}
			},

		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.percentage
			},
		}
	end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.hands) do
            v.l_mult = v.l_mult-card.ability.extra.added.hand[k]
        end
		for k, v in pairs(G.GAME.abn_rank_upgrades) do
            v.l_mult = v.l_mult-card.ability.extra.added.rank[k]
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.hands) do
            card.ability.extra.added.hand[k] = (v.l_mult+(v.l_mult*(card.ability.extra.percentage/100))) - v.l_mult
            v.l_mult = v.l_mult+(v.l_mult*(card.ability.extra.percentage/100))
        end
		for k, v in pairs(G.GAME.abn_rank_upgrades) do
            card.ability.extra.added.rank[k] = (v.l_mult+(v.l_mult*(card.ability.extra.percentage/100))) - v.l_mult
            v.l_mult = v.l_mult+(v.l_mult*(card.ability.extra.percentage/100))
        end
    end,
    in_pool = function(self)
        return false
    end,
	abn_artist_credits = {
		artist = "Pitissaria 2",
	},
})
