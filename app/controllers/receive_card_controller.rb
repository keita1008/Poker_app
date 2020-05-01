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

    if full_width_space?(@card)
      flash.now[:notice] = ERROR_MESSAGE3
      render("receive_card/top") and return
    end

    if not_five_cards?(@cards)
      flash.now[:notice] = "#{@cards.count}枚のカードが入力されています。" + "<br>#{ERROR_MESSAGE1}" + ERROR_MESSAGE5
      render("receive_card/top") and return
    end

    incorrect_card_messages = []
    if incorrect_cards?(@cards, incorrect_card_messages)
      flash.now[:notice] = incorrect_card_messages.join("<br>") + ERROR_MESSAGE4
      render("receive_card/top") and return
    end

    if duplicate_cards?(@cards)
      flash.now[:notice] = ERROR_MESSAGE2
      render("receive_card/top") and return
    end

    if straight_flash?(suits,numbers)
      @result = STRAIGHT_FLASH
      render("receive_card/top") and return
    end

    if four_of_a_kind?(numbers)
      @result = FOUR_OF_A_KIND
      render("receive_card/top") and return
    end

    if full_house?(numbers)
      @result = FULL_HOUSE
      render("receive_card/top") and return
    end

    if flash?(suits)
      @result = FLASH
      render("receive_card/top") and return
    end

    if straight?(numbers)
      @result = STRAIGHT
      render("receive_card/top") and return
    end

    if three_of_a_kind?(numbers)
      @result = THREE_OF_A_KIND
      render("receive_card/top") and return
    end

    if two_pair?(numbers)
      @result = TWO_PAIR
      render("receive_card/top") and return
    end

    if one_pair?(numbers)
      @result = ONE_PAIR
      render("receive_card/top") and return
    end

    if high_card?(numbers)
      @result = HIGH_CARD
      render("receive_card/top") and return
    end

    flash.now[:notice] = ERROR_MESSAGE6
    render("receive_card/top") and return

  end
end



