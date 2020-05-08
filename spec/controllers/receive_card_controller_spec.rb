require 'rails_helper'

include Common

RSpec.describe ReceiveCardController, type: :controller do

  describe '#check' do
    let(:params) {{ cards: "" }}
    subject { response }
    shared_examples "viewにrenderされるか" do
      it { is_expected.to render_template :top }
    end
    shared_examples "リクエストが成功しているか" do
      it { is_expected.to have_http_status(200) }
    end

    context "誤った値が入力されている場合" do

      context "カードが５枚入力されていない場合" do
        before do
          post :check, params.merge(cards: "H1 H2 H3 H4")
        end
        it_behaves_like "リクエストが成功しているか"
        it "エラーメッセージが返ってきているか" do
          expect(flash[:notice]).to eq "4枚のカードが入力されています。"
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "指定された値が入力されていない場合" do
        before do
          post :check, params.merge(cards: "H1 H2 H3 H4 A5")
        end
        it_behaves_like "リクエストが成功しているか"
        it "エラーメッセージが返ってきているか" do
          expect(flash[:notice]).to eq "5番目のカード指定文字が不正です。(A5)"
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "入力された値が重複している場合" do
        before do
          post :check, params.merge(cards: "H1 H2 H3 H4 H4")
        end
        it_behaves_like "リクエストが成功しているか"
        it "エラーメッセージが返ってきているか" do
          expect(flash[:notice]).to eq Common::ERROR_MESSAGE2
        end
        it_behaves_like "viewにrenderされるか"
      end

    end

    context "正しい値が入力されている場合" do

      context "ストレートフラッシュの場合" do
        before do
          post :check, params.merge(cards: "H1 H2 H3 H4 H5")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::STRAIGHT_FLASH
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "フラッシュの場合" do
        before do
          post :check, params.merge(cards: "H1 H12 H10 H5 H3")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::FLASH
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "ストレートの場合" do
        before do
          post :check, params.merge(cards: "H1 S2 C3 D4 H5")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::STRAIGHT
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "ハイカードの場合" do
        before do
          post :check, params.merge(cards: "D1 D10 S9 C5 C4")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::HIGH_CARD
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "ワンペアの場合" do
        before do
          post :check, params.merge(cards: "C10 S10 S6 H4 H2")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::ONE_PAIR
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "フォー・オブ・ア・カインドの場合" do
        before do
          post :check, params.merge(cards: "C10 D10 H10 S10 D5")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::FOUR_OF_A_KIND
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "フルハウスの場合" do
        before do
          post :check, params.merge(cards: "S10 H10 D10 S4 D4")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::FULL_HOUSE
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "スリー・オブ・ア・カインドの場合" do
        before do
          post :check, params.merge(cards: "S12 C12 D12 S5 C3")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::THREE_OF_A_KIND
        end
        it_behaves_like "viewにrenderされるか"
      end

      context "ツーペアの場合" do
        before do
          post :check, params.merge(cards: "H13 D13 C2 D2 H11")
        end
        it_behaves_like "リクエストが成功しているか"
        it "判定が返ってきているか" do
          expect(assigns(:result)).to eq Common::TWO_PAIR
        end
        it_behaves_like "viewにrenderされるか"
      end

    end
  end
end

