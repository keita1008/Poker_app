module API
  module Ver1
    class Poker < Grape::API

      helpers do
        include Common
      end

      resource :poker do
        version 'ver1'
        content_type :json, "application/json"
        format :json
        params do
          requires :cards, type: Array
        end
        post '/' do
          results = []
          errors = []
          @several_cards = params[:cards]
          @several_cards.each do |card|
            @card = card.split(" ")
            suits = []
            numbers = []
            split_card(@card,suits,numbers)

            incorrect_card_messages = []
            if incorrect_cards?(@card, incorrect_card_messages)
              @card = @card.join(" ")
              incorrect_card_messages.each do |incorrect_card_message|
                errors << {card: @card, msg: incorrect_card_message}
              end
              next
            end

            if not_five_cards?(@card)
              @result = Common::ERROR_MESSAGE1
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            end

            if duplicate_cards?(@card)
              @result = Common::ERROR_MESSAGE2
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            end

            if judge_hand(suits,numbers).present?
              @result = judge_hand(suits,numbers)
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

          end

          strongest_judge(results)

          if results.present? == true && errors.present? == true
            {
                "result": results,
                "error": errors
            }
          elsif results.present? == true && errors.present? == false
            {
                "result": results
            }
          else
            {
                "error": errors
            }
          end

        end
       end
     end
   end
end


