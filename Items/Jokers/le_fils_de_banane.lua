local le_fils_de_banane = {
    object_type = "Joker",
    order = 277,
    key = "le_fils_de_banane",
    config = {
      extra = {
          mult = 15,
          odds = 6
      }
    },
    rarity = 2,
    pos = { x = 0, y = 11},
    atlas = 'joker_atlas',
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
  
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
        return {
            vars = {
                numerator, denominator,
                card.ability.extra.mult
            }
        }
    end,
  
    calculate = function(self, card, context)
        if context.after and context.scoring_hand then
            local total_cards = {}
            local text,disp_text,poker_hands = G.FUNCS.get_poker_hand_info(G.play.cards)
            if not G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text, true) then
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then
                        if SMODS.pseudorandom_probability(card, 'le_fils_de_banane', 1, card.ability.extra.odds) and not context.scoring_hand[i].destroyed then
                            card_eval_status_text(context.scoring_hand[i], 'extra', nil, nil, nil, {message = localize('k_extinct_ex'),colour = G.C.FILTER})
                            table.insert(total_cards, context.scoring_hand[i])
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                func = function()
                                    context.scoring_hand[i]:start_dissolve()
                                    return true
                                end
                            })) 
                            context.scoring_hand[i].destroyed = true
                        else
                            card_eval_status_text(context.scoring_hand[i], 'extra', nil, nil, nil, {message = localize('k_safe_ex'),colour = G.C.FILTER})
                        end
                    end
                end
                SMODS.calculate_context({remove_playing_cards = true, removed = total_cards})
            end
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    mult = card.ability.extra.mult,
                    card = context.other_card
                }
            end
        end
    end
  
}
return { name = {"Jokers"}, items = {le_fils_de_banane} }
