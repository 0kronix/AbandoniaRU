SMODS.Joker {
    key = 'from_pixel_to_dust',

    rarity = 2,
    atlas = 'ABNJokerSheet19',
    pos = { x = 8, y = 3 },
    cost = 8,
    discovered = false,
    blueprint_compat = true,

    abn_artist_credits = {
        artist = "Weasel.922"
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == "unscored" then
            if not context.other_card.scoring_hand then
                return {
                    mult = context.other_card.base.nominal * 2,
                    card = card
                }
            end
        end

        if context.destroy_card and context.cardarea == "unscored" then
            return {
				remove = true
            }
        end
    end
}