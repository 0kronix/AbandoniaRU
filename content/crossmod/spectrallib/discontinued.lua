--track unique tags
local original_add_tag = add_tag
function add_tag(tag, immediate)
    if tag and tag.key then
        G.GAME.abn_SeenTags = G.GAME.abn_SeenTags or {}
        if not G.GAME.abn_SeenTags[tag.key] then
            G.GAME.abn_SeenTags[tag.key] = true
            G.GAME.abn_UniqueTags = (G.GAME.abn_UniqueTags or 0) + 1
        end
    end

    original_add_tag(tag, immediate)
end

SMODS.Enhancement({
  key = "discontinued",
  pos = { x = 5, y = 3 },
  atlas = "AbandoniaEnhancements",
  config = { extra = { ascension = 0, ascensionadd = 0.10, chips = 0, chipsadd = 10, } },
  loc_vars = function(self, info_queue, card)
    local cae = card.ability.extra
    return { vars = { cae.ascension, cae.chips, cae.ascensionadd, cae.chipsadd} }
  end,
  
  calculate = function(self, card, context)
	local cae = card.ability.extra
	cae.ascension = cae.ascensionadd * (G.GAME.abn_UniqueTags or 0)
	cae.chips = cae.chipsadd * (G.GAME.abn_UniqueTags or 0)
    if context.main_scoring and context.cardarea == G.play then
		return {
          asc = cae.ascension,
		  chips = cae.chips,
        }
    end
  end,
  abn_artist_credits = {
    artist = "Creechie",
  },
})