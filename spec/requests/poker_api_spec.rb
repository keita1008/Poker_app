require 'rails_helper'

include Common

RSpec.describe 'PokerAPI', type: :request do

  describe "POST /api/ver1/poker" do

    let(:path) { "/api/ver1/poker" }
    let(:request_header) do
      { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    let(:params) {{ cards: "" }}
    let(:response_body) {JSON.parse(response.body)}
    let(:result_cards) {response_body["result"].map{|hash| hash["card"]}}
    let(:result_hands) {response_body["result"].map{|hash| hash["hand"]}}
    let(:result_best) {response_body["result"].map{|hash| hash["best"]}}
    let(:error_cards) {response_body["error"].map{|hash| hash["card"]}}
    let(:error_messages) {response_body["error"].map{|hash| hash["msg"]}}
    subject { response }
    shared_examples "201 OKを返す" do
      it { is_expected.to have_http_status(201) }
    end

    context "正しい値のみを入力した場合" do
      before do
        post path, params.merge(cards: ["C7 C6 C5 C4 C3","S8 S7 H6 H5 S4","D1 D10 S9 C5 C4"])
      end
      it_behaves_like "201 OKを返す"
      it "errorが返ってこない" do
        expect(response_body["error"]).to be nil
      end

      context "resultが返ってくる場合" do
        it "resultが返ってくる" do
          expect(response_body["result"]).to be_present
        end

        context "cardが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_cards[0]).to eq "C7 C6 C5 C4 C3"
          end
          it "期待値が返ってくる" do
            expect(result_cards[1]).to eq "S8 S7 H6 H5 S4"
          end
          it "期待値が返ってくる" do
            expect(result_cards[2]).to eq "D1 D10 S9 C5 C4"
          end
        end

        context "handが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_hands[0]).to eq Common::STRAIGHT_FLASH
          end
          it "期待値が返ってくる" do
            expect(result_hands[1]).to eq Common::STRAIGHT
          end
          it "期待値が返ってくる" do
            expect(result_hands[2]).to eq Common::HIGH_CARD
          end
        end

        context "bestが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_best[0]).to eq true
          end
          it "期待値が返ってくる" do
            expect(result_best[1]).to eq false
          end
          it "期待値が返ってくる" do
            expect(result_best[2]).to eq false
          end
        end

      end

    end

    context "正しい値と誤った値を入力した場合" do
      before do
        post path, params.merge(cards: ["S12 C12 D12 S5 C3","H1 H2 H3 H4 H5","H1 H2 H3 H4 A5"])
      end
      it_behaves_like "201 OKを返す"

      context "resultが返ってくる場合" do
        it "resultが返ってくる" do
          expect(response_body["result"]).to be_present
        end

        context "cardが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_cards[0]).to eq "S12 C12 D12 S5 C3"
          end
          it "期待値が返ってくる" do
            expect(result_cards[1]).to eq "H1 H2 H3 H4 H5"
          end
        end

        context "handが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_hands[0]).to eq Common::THREE_OF_A_KIND
          end
          it "期待値が返ってくる" do
            expect(result_hands[1]).to eq Common::STRAIGHT_FLASH
          end
        end

        context "bestが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(result_best[0]).to eq false
          end
          it "期待値が返ってくる" do
            expect(result_best[1]).to eq true
          end
        end

      end

      context "errorが返ってくる場合" do
        it "errorが返ってくる" do
          expect(response_body["error"]).to be_present
        end

        context "cardが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(error_cards[0]).to eq "H1 H2 H3 H4 A5"
          end
        end

        context "msgが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(error_messages[0]).to eq "5番目のカード指定文字が不正です。(A5)"
          end
        end

      end

    end

    context "誤った値のみを入力した場合" do
      before do
        post path, params.merge(cards: ["","H1 H2 H3 H4 H4","H1 H2 H3 H4 A5"])
      end
      it_behaves_like "201 OKを返す"
      it "resultが返ってこない" do
        expect(response_body["result"]).to be nil
      end

      context "errorが返ってくる場合" do
        it "errorが返ってくる" do
          expect(response_body["error"]).to be_present
        end

        context "cardが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(error_cards[0]).to eq ""
          end
          it "期待値が返ってくる" do
            expect(error_cards[1]).to eq "H1 H2 H3 H4 H4"
          end
          it "期待値が返ってくる" do
            expect(error_cards[2]).to eq "H1 H2 H3 H4 A5"
          end
        end

        context "msgが返ってくる場合" do
          it "期待値が返ってくる" do
            expect(error_messages[0]).to eq Common::ERROR_MESSAGE1
          end
          it "期待値が返ってくる" do
            expect(error_messages[1]).to eq Common::ERROR_MESSAGE2
          end
          it "期待値が返ってくる" do
            expect(error_messages[2]).to eq "5番目のカード指定文字が不正です。(A5)"
          end
        end

      end

    end

  end
 end