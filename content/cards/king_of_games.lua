G.FUNCS.tag_abn_nonstandard_set_suit = function(e)
    if G.customize_card and G.customize_card.cards[1] then
        local card = G.customize_card.cards[1]
        for key, suit in pairs(SMODS.Suits) do
            if localize(key, "suits_singular") == e.to_val then
                card:change_suit(key)
                break
            end
        end
    end
end

G.FUNCS.tag_abn_nonstandard_set_rank = function(e)
    if G.customize_card and G.customize_card.cards[1] then
        local card = G.customize_card.cards[1]
        for key, rank in pairs(SMODS.Ranks) do
            if localize(key, "ranks") == e.to_val then
                if card.base and card.base.suit then
                    local suit_prefix = SMODS.Suits[card.base.suit] and SMODS.Suits[card.base.suit].card_key or card.base.suit:sub(1, 1)
                    local card_key = suit_prefix .. "_" .. (rank.card_key or key)
                    if G.P_CARDS[card_key] then
                        card:set_base(G.P_CARDS[card_key])
                    else
                        card:set_base(rank)
                    end
                else
                    card:set_base(rank)
                end
                break
            end
        end
    end
end

G.FUNCS.tag_abn_nonstandard_set_enhancement = function(e)
    if G.customize_card and G.customize_card.cards[1] then
        local card = G.customize_card.cards[1]
        if e.to_val == localize("k_none") then
            card:set_ability(G.P_CENTERS.c_base)
        else
            for _, center in pairs(G.P_CENTER_POOLS.Enhanced) do
                if localize{ key = center.key, set = "Enhanced", type = "name_text" } == e.to_val then
                    card:set_ability(center)
                    break
                end
            end
        end
    end
end

G.FUNCS.king_of_games_set_submit = function(e)
    if G.customize_card and G.customize_card.cards[1] then
        local custom_card = G.customize_card.cards[1]

        local card_front = custom_card.config.card or G.P_CARDS["D_A"]
        local card_center = custom_card.config.center or G.P_CENTERS.c_base
        local card_base = custom_card.base

        -- Store reference to the Joker passed through ref_table
        local joker_card = e.config and e.config.ref_table

        G.FUNCS.exit_overlay_menu()

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local new_card = create_playing_card(
                    {
                        front = card_front,
                        center = card_center
                    },
                    G.hand,
                    nil,
                    true,
                    { G.C.SECONDARY_SET.Enhanced }
                )

                if card_base then
                    new_card:set_base(card_base)
                end
                if card_center then
                    new_card:set_ability(card_center)
                end

                if card_base and card_base.suit and card_base.value then
                    local suit_prefix = SMODS.Suits[card_base.suit] and SMODS.Suits[card_base.suit].card_key or card_base.suit:sub(1, 1)
                    local rank_key = SMODS.Ranks[card_base.value] and SMODS.Ranks[card_base.value].card_key or card_base.value
                    local card_key = suit_prefix .. "_" .. rank_key
                    
                    if G.P_CARDS[card_key] then
                        new_card.config.card = G.P_CARDS[card_key]
                    end
                end
                
                new_card:set_sprites(new_card.config.center, new_card.config.card)

                if G.GAME and G.GAME.blind then
                    G.GAME.blind:debuff_card(new_card)
                end
                G.hand:sort()

                -- Triggers "Heart of the cards!" popup on the Joker (or new card fallback) AFTER creation finishes
                card_eval_status_text(joker_card or new_card, 'extra', nil, nil, nil, {
                    message = "Heart of the cards!",
                    colour = G.C.SUITS.Hearts
                })
                
                return true
            end
        }))
    end
end

function create_UIBox_king_of_games(joker_card)
    G.customize_card = CardArea(
        0, 0,
        math.min(math.max(1 * G.CARD_W * 0.6, 4 * G.CARD_W), 10 * G.CARD_W),
        1.4 * G.CARD_H,
        { card_limit = 1, type = 'play', highlight_limit = 0 }
    )

    local card = Card(
        G.customize_card.T.x + G.customize_card.T.w / 2,
        G.customize_card.T.y + G.customize_card.T.h / 2,
        G.CARD_W * 1.2,
        G.CARD_H * 1.2,
        G.P_CARDS["D_A"],
        G.P_CENTERS.c_base
    )
    card.ability.jest_copy_edition = true
    G.customize_card:emplace(card)

    local suit_pool = {}
    for suit_key, _ in pairs(SMODS.Suits) do
        table.insert(suit_pool, suit_key)
    end
    table.sort(suit_pool, function(a, b)
        return SMODS.Suits[a].suit_nominal < SMODS.Suits[b].suit_nominal
    end)
    for i, suit_key in ipairs(suit_pool) do
        suit_pool[i] = localize(suit_key, "suits_singular")
    end
    local suits_option_cycle = create_option_cycle({
        label = "Set Suit", text_scale = 0.4, scale = 0.8, w = 3,
        options = suit_pool, opt_callback = "tag_abn_nonstandard_set_suit", current_option = 1
    })

    local rank_pool = {}
    for rank_key, _ in pairs(SMODS.Ranks) do
        table.insert(rank_pool, rank_key)
    end
    table.sort(rank_pool, function(a, b)
        return (a == "Ace" and -1 or SMODS.Ranks[a].sort_nominal) < (b == "Ace" and -1 or SMODS.Ranks[b].sort_nominal)
    end)
    for i, rank_key in ipairs(rank_pool) do
        rank_pool[i] = localize(rank_key, "ranks")
    end
    local ranks_option_cycle = create_option_cycle({
        label = "Set Rank", text_scale = 0.4, scale = 0.8, w = 3,
        options = rank_pool, opt_callback = "tag_abn_nonstandard_set_rank", current_option = 1
    })

    local enhancement_pool = { localize("k_none") }
    for _, enhancement in pairs(get_current_pool("Enhanced")) do
        if enhancement ~= "UNAVAILABLE" then
            table.insert(enhancement_pool, localize{ key = enhancement, set = "Enhanced", type = "name_text" })
        end
    end
    local enhancements_option_cycle = create_option_cycle({
        label = "Enhancement", text_scale = 0.4, scale = 0.8, w = 3,
        options = enhancement_pool, opt_callback = "tag_abn_nonstandard_set_enhancement", current_option = 1
    })

    local create_label = "Create"
    if G.localization.misc.dictionary.k_abn_create then
        create_label = localize("k_abn_create")
    end

    local t = create_UIBox_generic_options({
        back_func = 'exit_overlay_menu',
        back_label = localize("b_skip"),
        snap_back = true,
        contents = {
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.07, no_fill = true },
                nodes = {
                    { n = G.UIT.O, config = { object = G.customize_card } },
                }
            },
            UIBox_button{ label = { create_label }, button = "king_of_games_set_submit", ref_table = joker_card, minw = 5 },
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.BLACK, r = 0.1 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "tm", colour = G.C.BLACK, r = 0.1 },
                        nodes = {
                            suits_option_cycle,
                            ranks_option_cycle,
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "tm", colour = G.C.BLACK, r = 0.1 },
                        nodes = {
                            enhancements_option_cycle,
                        }
                    }
                }
            },
        }
    })
    return t
end

SMODS.Joker {
    key = 'king_of_games',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.used_this_blind and "Inactive" or "Active" } }
    end,

    rarity = 3,
    atlas = 'ABNJokerSheet19',
    pos = { x = 2, y = 0 },
    cost = 10,
    discovered = false,
    blueprint_compat = false,

    config = { extra = { used_this_blind = false } },

    abn_artist_credits = {
        artist = "Comykel"
    },
    abn_use_config = { colour = G.C.BLUE, text = "CREATE" },

    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and not card.ability.extra.used_this_blind 
    end,

    use = function(self, card)
        card.ability.extra.used_this_blind = true
        G.FUNCS.overlay_menu{
            config = { no_esc = true },
            definition = create_UIBox_king_of_games(card)
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind and G.GAME.blind.boss then
            card.ability.extra.used_this_blind = false
        end
    end
}