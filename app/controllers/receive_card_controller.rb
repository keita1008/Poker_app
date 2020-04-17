class ReceiveCardController < ApplicationController

  include Common

  def top
  end

  def check

    @card = params[:cards]
    @cards = @card.split(" ")
    suits = []
    numbers = []
    split_card(@cards,suits,numbers)

    if not_five_cards?(@cards)
      flash.now[:notice] = ERROR_MESSAGE1
      render("receive_card/top") and return
    end

    if incorrect_cards?(@cards)
      flash.now[:notice] = ERROR_MESSAGE2
      render("receive_card/top") and return
    end

    if duplicate_cards?(@cards)
      flash.now[:notice] = ERROR_MESSAGE3
      render("receive_card/top") and return
    end

    if straight_flash?(suits,numbers)
      @result = STRAIGHT_FLASH
    elsif flash?(suits)
      @result = FLASH
    else
      if straight?(numbers)
        @result = STRAIGHT
      elsif high_card?(numbers)
        @result = HIGH_CARD
      elsif one_pair?(numbers)
        @result = ONE_PAIR
      elsif four_of_a_kind(numbers)
        @result = FOUR_OF_A_KIND
      elsif full_house(numbers)
        @result = FULL_HOUSE
      elsif three_of_a_kind(numbers)
        @result = THREE_OF_A_KIND
      else two_pair?(numbers)
        @result = TWO_PAIR
      end
    end

    render("receive_card/top")

  end

end



