module API
  module Ver1
    class Poker < Grape::API

      helpers do
        include Common
      end

      resource :poker do
        version 'ver1'
        format :json
        # GET /api/ver1/poker
        desc 'ポーカーの役を返す'
        # prefix 'poker/'
        post '/' do

          @several_cards = params[:cards]
          results = []
          errors = []
          @several_cards.each do |card|
            @card = card.split(" ")
            suits = []
            numbers = []
            split_card(@card,suits,numbers)

            if not_five_cards?(@card)
              @result = Common::ERROR_MESSAGE1
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            elsif incorrect_cards?(@card)
              @result = Common::ERROR_MESSAGE2
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            elsif duplicate_cards?(@card)
              @result = Common::ERROR_MESSAGE3
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            else
              if straight_flash?(suits,numbers)
                @result = Common::STRAIGHT_FLASH
              elsif flash?(suits)
                @result = Common::FLASH
              else
                if straight?(numbers)
                  @result = Common::STRAIGHT
                elsif high_card?(numbers)
                  @result = Common::HIGH_CARD
                elsif one_pair?(numbers)
                  @result = Common::ONE_PAIR
                elsif four_of_a_kind(numbers)
                  @result = Common::FOUR_OF_A_KIND
                elsif full_house(numbers)
                  @result = Common::FULL_HOUSE
                elsif three_of_a_kind(numbers)
                  @result = Common::THREE_OF_A_KIND
                else two_pair?(numbers)
                  @result = Common::TWO_PAIR
                end
              end
            end

            @card = @card.join(" ")
            results << {card: @card, hand: @result, best: Score(@result)}
          end

          temp_results = results.map{|hash| hash[:best]}
          strongest_num = temp_results.min
          results.each do |result|
            if result[:best] == strongest_num
              result[:best] = true
            else
              result[:best] = false
            end
          end

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


