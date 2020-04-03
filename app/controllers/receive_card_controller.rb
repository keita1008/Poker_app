class ReceiveCardController < ApplicationController
  def top
  end
  def check
    @card = params[:cards]
    if a == "1"
      @result = 10
    else
      @result = 20
    end

    render("receive_card/top")
  end
end
