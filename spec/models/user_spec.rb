require 'rails_helper'

# 모델(User)에 관한 테스트는 명식적으로 테스트 종류를 적지 않아도 rspec이 자동으로 판단함
describe User do
  # Rspec에서의 변수 선언
  let(:nickname) { 'test name' }
  let(:email) { 'test@example.com' }
  let(:password) { '11111111' }
  let(:user) { User.new(nickname: nickname, email: email, password: password, password_confirmation: password) }

  describe '.first' do
    # 테스트를 하기 전 실행하는 것
    before do
      # 팩토리봇 -> 팩토리봇 코드에 user를 가지고 옴
      # 팩토리봇을 사용하면 사전에 다양한 정보를 만들 수 있음
      create(:user, nickname: nickname, email: email)
    end

    # described_class: 위의 User 클래스를 가리킴 = User.first
    # subject라는 변수를 정의
    subject { described_class.first }

    it '仕事に作成した通りのUserを返す' do
      expect(subject.nickname).to eq('test name')
      expect(subject.email).to eq('test@example.com')
    end
  end

  # 기능에 대한 계층구조 validation
  describe 'validation' do
    describe 'nickname属性' do
      describe '文字数制限の検証' do # 문자수 제한의 validation
        context "nicknameが20文字以下の場合" do
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてと' } # 20文字

          it 'User オブジェクトは有効である' do # 20자 이하의 validate가 성공했을 때
            expect(user.valid?).to be(true)
          end
        end

        context "nicknameが20文字超える場合" do
          let(:nickname) { 'あいうえおかきくけこさしすせそたちつてとな' } # 21文字

          it 'User オブジェクトは無効である' do # 20자 이상의 validate가 실패했을 때
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include('is too long (maximum is 20 characters)')
          end
        end
      end

      describe 'nickname存在性の検証' do
        context "nicknameが空欄の場合" do
          let(:nickname) { '' }

          it 'User オブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include("can't be blank")
          end
        end
      end
    end
  end
end
