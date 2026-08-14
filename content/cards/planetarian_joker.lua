SMODS.Joker {
    key = 'planetarian_joker',

    atlas = 'ABNJokerSheet20',
    pos = { x = 2, y = 2 },

    cost = 6,
    rarity = 3,

    abn_coder = "LasagnaFelidae",

    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            chips = 0,
            mult = 0,
            min = 9
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_black_hole
        local ct = 0
        if G.GAME.unique_rank_planets then
            for _ in pairs(G.GAME.unique_rank_planets) do
                ct = ct + 1
            end
        end
        return { 
            vars = { 
                card.ability.extra.chips, 
                card.ability.extra.mult,
                card.ability.extra.min,
                ct
            } 
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability 
            and context.consumeable.ability.set == "Planet" then
                if context.consumeable.ability.hand_type then
                    local hand_type = context.consumeable.ability.hand_type
                    if G.GAME.hands[hand_type] and G.GAME.hands[hand_type].l_chips and G.GAME.hands[hand_type].l_mult then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_value = "l_chips",
                            scalar_table = G.GAME.hands[hand_type]
                        })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "mult",
                            scalar_value = "l_mult",
                            scalar_table = G.GAME.hands[hand_type]
                        })
                    end
                end
                if context.consumeable.config
                and context.consumeable.config.center
                and context.consumeable.config.center.attributes then
                    for _, attr in ipairs(context.consumeable.config.center.attributes) do
                        if attr == "rank_planet" then
                            local ct = 0
                            for _ in pairs(G.GAME.unique_rank_planets) do
                                ct = ct + 1
                            end

                            if ct >= card.ability.extra.min and G.consumeables and (#G.consumeables.cards + (G.GAME.consumeable_buffer or 0) < G.consumeables.config.card_limit) then
                                G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        local bh = SMODS.create_card({
                                            set = 'Spectral',
                                            key = 'c_black_hole',
                                            area = G.consumeables
                                        })
                                        bh:add_to_deck()
                                        G.consumeables:emplace(bh)
                                        G.GAME.consumeable_buffer = 0
                                        G.GAME.unique_rank_planets = {}
                                        return true
                                    end
                                }))
                            end
                            
                        end
                    end
                end
            end
        end
    end,

    in_pool = function(self, args)
        if not G.playing_cards then return false end
        for _, playing_card in ipairs(G.playing_cards) do
        if SMODS.has_enhancement(playing_card, "m_abn_teastain") or SMODS.has_enhancement(playing_card, "m_abn_teatag") then
            return true
        end
        end
        return false
    end,
    abn_artist_credits = { artist = "Mini Bit" },
}


local use_consumeable_ref = Card.use_consumeable
function Card:use_consumeable(area, copier)
  local g = use_consumeable_ref(self, area, copier)
    if self.ability.set == "Planet" 
    and self.config
    and self.config.center
    and self.config.center.attributes then
        for _, attr in ipairs(self.config.center.attributes) do
            if attr == "rank_planet" then
                local key = self.config.center.key 
                if not G.GAME.unique_rank_planets then G.GAME.unique_rank_planets = {} end
                if not G.GAME.unique_rank_planets[key] then
                    G.GAME.unique_rank_planets[key] = 1
                else
                    G.GAME.unique_rank_planets[key] = G.GAME.unique_rank_planets[key] + 1
                end
                break
            end
        end
    end
    return g
end