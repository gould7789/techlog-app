require 'rails_helper'

RSpec.describe "Homes", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'トップページの検証' do
    it 'Home#topという文字列が表示される' do
      visit '/'

      expect(page).to have_content('Home#top')
    end
  end

  # 로그인 했을 때와 하지 않았을 때, 두 개의 상황(context)를 가정
  describe 'ナビゲーションバーの検証' do
    # 로그인 안 했을 때(비회원)
    context "ログインしてない場合" do
      # 테스트 시작 전 메인 페이지로 이동
      before { visit '/' }

      # 회원가입 버튼이 있어야 함 (링크 주소까지 확인)
      it 'ユーザー登録リンクを表示する' do
        expect(page).to have_link('ユーザー登録', href: new_user_registration_path)
      end

      # 로그인 버튼이 있어야 함
      it 'ログインリンクを表示する' do
        expect(page).to have_link('ログイン', href: new_user_session_path)
      end

      # 로그아웃 버튼은 없어야 함 (로그인도 하지 않았는데 로그아웃이 보이면 안 되니까)
      it 'ログアウトリンクは表示しない' do
        expect(page).not_to have_content('ログアウト')
      end
    end

    # 로그인 했을 때(회원)
    context "ログインしている場合" do
      before do
        # 가상 유저 한 명을 공장에서 만들어 냄
        user = create(:user) # ログイン用のユーザーを作成 -> factorybot에 설정해놨던 user를 가져옴
        # 그 유저로 '로그인' 시킴
        sign_in user # 作成したユーザーでログイン
        # 로그인 상태로 메인 페이지 접속
        visit '/'
      end

      # 회원가입 버튼은 필요 없음 -> 이미 회원이니까
      it 'ユーザー登録リンクは表示しない' do
        expect(page).not_to have_link('ユーザー登録', href: new_user_registration_path)
      end

      # 로그인 버튼은 필요 없음
      it 'ログインリンクは表示しない' do
        expect(page).not_to have_link('ログイン', href: new_user_session_path)
      end

      # 로그아웃 버튼은 보여야 함
      it 'ログアウトリンクを表示する' do
        expect(page).to have_content('ログアウト')
      end

      # 로그아웃 버튼을 누르면?
      it 'ログアウトリンクが機能する' do
        click_button 'ログアウト'

        # 버튼을 누르면 다시 '비회원 모드' 화면으로 돌아가야 함
        # ログインしてない状態のリンク表示パターンになることを確認
        expect(page).to have_link('ユーザー登録', href: new_user_registration_path) # 가입 버튼 다시 표시
        expect(page).to have_link('ログイン', href: new_user_session_path)     # 로그인 버튼 다시 표시
        expect(page).not_to have_content('ログアウト')                    # 로그아웃 버튼은 사라짐
      end
    end
  end
end
