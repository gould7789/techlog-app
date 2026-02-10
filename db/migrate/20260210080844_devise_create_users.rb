# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      # Confirmable
      # 이메일로 보내는 긴 링크 뒤에 붙어있는 암호. 사용자가 링크를 클릭하면 서버는 번호를 대조함.
      t.string   :confirmation_token
      # 사용자가 이메일 링크를 클릭해서 인증을 완료한 시간.
      # 이 칸이 비어있다(nil) -> 아직 인증 안 한 사람(로그인 차단)
      # 날짜가 적혀있음 -> 인증 완료된 사람(로그인 허용)
      t.datetime :confirmed_at
      # 이메일을 언제 보냈는지 기록
      # 이메일 인증 기간이 지났는지 확인할 때 사용
      t.datetime :confirmation_sent_at
      # 회원이 이미 가입된 상태에서 이메일을 바꿀 때 씀
      # 새 이메일(new@test.com)로 인증하기 전까지는, 일단 여기에 임시로 저장해두고
      # 로그인은 옛날 이메일(old@test.com)으로 하게함 (인증이 완료되면 진짜 이메일 칸으로 옮겨짐)
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    # 데이터베이스는 데이터가 많아지면 찾는 속도가 느려짐. 그러므로 자주 검색하는 것을 미리 정렬
    # add_index: 이메일을 가나다순으로 정리'
    # unique: true: 중복 금지
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true

    # 인증 번호(confirmation_token)도 겹치면 안 됨(unique)
    add_index :users, :confirmation_token,   unique: true

    # # 계정 잠금 기능을 사용할 때 사용
    # add_index :users, :unlock_token,         unique: true
  end
end
