Rails.application.routes.draw do
  get "/" => "receive_card#top"
  get "check" => "receive_card#check"
end
