local stellar_shader = {
    object_type = "Shader",
    key = 'stellar', 
    path = 'stellar.fs',
}
SMODS.Sound {
  key = 'stellar',
  path = 'stellar.mp3'
}
local stellar = {
    object_type = "Edition",
    key = 'stellar', 
    sound = {
        sound = 'aij_stellar',
        per = 1,
        vol = 1
    },
    order = 2,
    config = { chip_mod = 5, mult_mod = 1 },
    loc_vars = function(self, info_queue, card)
        return {vars = {(card.edition or {}).chip_mod or self.config.chip_mod, (card.edition or {}).mult_mod or self.config.mult_mod}}
    end,
    calculate = function(self, card, context)
		if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            local chip = to_number(G.GAME.hands[context.scoring_name].level) * card.edition.chip_mod
            local mul = to_number(G.GAME.hands[context.scoring_name].level) * card.edition.mult_mod
			return {
				chips = chip,
				mult = mul
			}
		end
	end,
    in_shop = true,
    weight = 10,
    extra_cost = 2,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'stellar',
}

if JokerDisplay then
    local jd_edition_def = JokerDisplay.Edition_Definitions

    jd_edition_def["e_aij_stellar"] = {
        condition_function = function(card)
            local edition = card.edition
            return not card.debuff and edition and card.edition.key and card.edition.key == "e_aij_stellar"
        end,
        mod_function = function(card)
            local edition = card.edition
            local hand_text, _, _ = JokerDisplay.evaluate_hand()

            local chip = 0
            local mult = 0
            if hand_text ~= 'Unknown' and G.GAME.hands[hand_text] then
                chip = to_number(G.GAME.hands[hand_text].level) * edition.chip_mod
                mult = to_number(G.GAME.hands[hand_text].level) * edition.mult_mod
            end
            
            return { chips = chip, mult = mult }
        end
    }
end

return {name = "Editions", items = {stellar, stellar_shader}}
