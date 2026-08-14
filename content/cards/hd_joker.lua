local Card_set_debuff = Card.set_debuff
function Card:set_debuff(should_debuff)
  if self.config and self.config.center then
    
    if next(SMODS.find_card("j_abn_hd_joker")) then
      if self.config.center.set == "Joker" and self.config.center.rarity and self.config.center.rarity == 1 and not self.edition then                                                     
        self.debuff = false
        return
      end
    end

  end

  Card_set_debuff(self, should_debuff)
end

SMODS.Joker {
    key = 'hd_joker',
    rarity = 1,
    atlas = 'ABNJokerSheet19', 
    pos = { x = 1, y = 3 }, 
    cost = 8,
    discovered = false,
    blueprint_compat = true,
    
	add_to_deck = function(self, card)
		G.GAME.uncommon_mod = 0
        G.GAME.rare_mod = 0
    end,
	
	remove_from_deck = function(self, card)
        G.GAME.uncommon_mod = 1
        G.GAME.rare_mod = 1
    end,

    abn_artist_credits = {
        artist = "Gud",
    },
}