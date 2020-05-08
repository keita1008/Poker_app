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

    error_messages = []

    if judge_error(@cards,@card,error_messages)
      flash.now[:notice] = error_messages.join("<br>")
      render("receive_card/top") and return
    end

    if judge_hand(suits,numbers).present?
      @result = judge_hand(suits,numbers)
      render("receive_card/top") and return
    end

    flash.now[:notice] = ERROR_MESSAGE4
    render("receive_card/top") and return

  end
end



