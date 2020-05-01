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
        rescue_from :all do |e|
          error!("rescued from #{e.class.name}")
        end
        rescue_from Encoding::UndefinedConversionError, Grape::Exceptions::InvalidMessageBody do |e|
          error!("rescued from #{e.class.name}")# エラーハンドリング処理
        end

        desc 'ポーカーの役を返す'
        # prefix 'poker/'
        post '/' do

          results = []
          errors = []
          @several_cards = params[:cards]
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
            end

            incorrect_card_messages = []
            if incorrect_cards?(@card, incorrect_card_messages)
              @card = @card.join(" ")
              incorrect_card_messages.each do |incorrect_card_message|
                errors << {card: @card, msg: incorrect_card_message}
              end
              next
            end

            if duplicate_cards?(@card)
              @result = Common::ERROR_MESSAGE2
              @card = @card.join(" ")
              errors << {card: @card, msg: @result}
              next
            end

            if straight_flash?(suits,numbers)
              @result = Common::STRAIGHT_FLASH
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if flash?(suits)
              @result = Common::FLASH
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if straight?(numbers)
              @result = Common::STRAIGHT
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if high_card?(numbers)
              @result = Common::HIGH_CARD
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if one_pair?(numbers)
              @result = Common::ONE_PAIR
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if four_of_a_kind?(numbers)
              @result = Common::FOUR_OF_A_KIND
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if full_house?(numbers)
              @result = Common::FULL_HOUSE
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if three_of_a_kind?(numbers)
              @result = Common::THREE_OF_A_KIND
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

            if two_pair?(numbers)
              @result = Common::TWO_PAIR
              @card = @card.join(" ")
              results << {card: @card, hand: @result, best: Score(@result)}
              next
            end

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


