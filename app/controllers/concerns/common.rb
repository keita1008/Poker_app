module Common
  extend ActiveSupport::Concern

  STRAIGHT_FLASH = "ストレートフラッシュ"
  FOUR_OF_A_KIND = "フォー・オブ・ア・カインド"
  FULL_HOUSE = "フルハウス"
  FLASH = "フラッシュ"
  STRAIGHT = "ストレート"
  THREE_OF_A_KIND = "スリー・オブ・ア・カインド"
  TWO_PAIR = "ツーペア"
  ONE_PAIR = "ワンペア"
  HIGH_CARD = "ハイカード"
  ERROR_MESSAGE1 = "5つのカード指定文字を半角スペース区切りで入力してください。"
  ERROR_MESSAGE2 = "カードが重複しています"
  ERROR_MESSAGE5 = "<br>(例：S1 H3 D9 C13 S11 ）"
  ERROR_MESSAGE3 = "全角スペースが含まれています。<br>5つのカード指定文字を半角スペース区切りで入力してください。" + ERROR_MESSAGE5
  ERROR_MESSAGE4 = "<br>半角英字大文字のスート（S,H,D,C）と半角数字（1〜13）の組み合わせでカードを指定してください。"
  ERROR_MESSAGE6 = "不正な入力です" + "<br>#{ERROR_MESSAGE1}" + ERROR_MESSAGE5

  def split_card(cards,suits,numbers)
    cards.each do |card|
      suit = card.delete("0-9")
      suits << suit
      num = card.delete("S|H|D|C")
      numbers << num.to_i
    end
  end

  def not_five_cards?(cards)
    cards.count != 5 ? true : false
  end

  def full_width_space?(card)
    card.match(/[\u3000]/) ? true : false
  end

  def incorrect_cards?(cards, incorrect_card_messages)

    cards.each_with_index do |card, i|
      if !(card.match(/\A([SHDC])([1][0-3]|[1-9])\z/))
      msg = "#{i+1}番目のカード指定文字が不正です。(#{card})"
      incorrect_card_messages << msg
      end
    end

    incorrect_card_messages.present? ? true : false

  end

  def duplicate_cards?(cards)
    cards.uniq.count != 5 ? true : false
  end

  def straight?(numbers)
    numbers.max - numbers.min == 4 && numbers.uniq.count == 5 || numbers.sort == [1, 10, 11, 12, 13]
  end

  def flash?(suits)
    suits.uniq.count == 1
  end

  def straight_flash?(suits,numbers)
    straight?(numbers) && flash?(suits)
  end

  def high_card?(numbers)
    numbers.uniq.count == 5
  end

  def one_pair?(numbers)
    numbers.uniq.count == 4
  end

  def two_pair?(numbers)
    numbers.uniq.count == 3
  end

  def three_of_a_kind?(numbers)
    numbers.count(numbers[0]) == 3 || numbers.count(numbers[2]) == 3 || numbers.count(numbers[4]) == 3
  end

  def full_house?(numbers)
    numbers.uniq.count == 2
  end

  def four_of_a_kind?(numbers)
    numbers.uniq.count == 2 && numbers.count(numbers[0]) == 4 || numbers.count(numbers[4]) == 4
  end

  def Score(hands)
    case hands
    when STRAIGHT_FLASH ; return 0
    when FOUR_OF_A_KIND ; return 1
    when FULL_HOUSE ; return 2
    when FLASH ; return 3
    when STRAIGHT ; return 4
    when THREE_OF_A_KIND ; return 5
    when TWO_PAIR ; return 6
    when ONE_PAIR ; return 7
    when HIGH_CARD ; return 8
    end
  end

end