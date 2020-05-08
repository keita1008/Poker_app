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
  ERROR_MESSAGE1 = "5つの半角英字大文字のスート（S,H,D,C）と半角数字（1〜13）の組み合わせを半角スペース区切りで入力してください。"
  ERROR_MESSAGE2 = "カードが重複しています"
  ERROR_MESSAGE3 = "全角スペースが含まれています。"
  ERROR_MESSAGE4 = "不正な入力です"

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

  def duplicate_cards?(cards)
    duplicate_card = cards.select{ |e| cards.count(e) > 1 }.uniq
    duplicate_card.present? ? true : false
  end

  def incorrect_cards?(cards, error_messages)
    cards.each_with_index do |card, i|
      unless card.match(/\A([SHDC])([1][0-3]|[1-9])\z/)
        msg = "#{i+1}番目のカード指定文字が不正です。(#{card})"
        error_messages << msg
      end
    end
    error_messages.present? ? true : false
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

  def judge_error(cards,card,error_messages)
    error_messages << "#{cards.count}枚のカードが入力されています。" if not_five_cards?(cards)
    error_messages << ERROR_MESSAGE3                             if full_width_space?(card)
    error_messages << ERROR_MESSAGE2                             if duplicate_cards?(cards)
    incorrect_cards?(cards, error_messages)
    return true if error_messages.present?
  end

  def judge_hand(suits,numbers)
    return STRAIGHT_FLASH  if straight?(numbers) && flash?(suits)
    return STRAIGHT        if straight?(numbers)
    return FLASH           if flash?(suits)
    return HIGH_CARD       if high_card?(numbers)
    return ONE_PAIR        if one_pair?(numbers)
    return FOUR_OF_A_KIND  if four_of_a_kind?(numbers)
    return FULL_HOUSE      if full_house?(numbers)
    return THREE_OF_A_KIND if three_of_a_kind?(numbers)
    return TWO_PAIR        if two_pair?(numbers)
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

  def strongest_judge(results)
    temp_results = results.map{|hash| hash[:best]}
    strongest_num = temp_results.min
    results.each do |result|
      if result[:best] == strongest_num
        result[:best] = true
      else
        result[:best] = false
      end
    end
  end

end