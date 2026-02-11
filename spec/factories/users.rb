FactoryBot.define do
  factory :user do
    nickname { 'test name' }
    sequence :email do |n| # sequence: 자동으로 번호를 갱신해줌. n이 1씩 더해짐.
      "test#{n}@example.com"
    end
    password { '11111111' }
    password_confirmation { '11111111' } # 비밀번호 확인 입력으로 한 번 더 확인
  end
end
