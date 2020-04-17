require 'grape'
module API
  class Root < Grape::API
    prefix 'api'
    mount API::Ver1::Poker

    get do


    end
  end
end

