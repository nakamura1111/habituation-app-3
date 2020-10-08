require 'rails_helper'

RSpec.describe '新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # ログインページに遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 新規登録ボタンをクリックする
      find_link('新規登録はこちら', href: new_user_registration_path).click
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: @user.nickname
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password
      # サインアップボタンを押すとユーザーモデルのカウントが1上がる
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移しているか確認
      expect(current_path).to eq(root_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # ログインページに遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 新規登録ボタンをクリックする
      find_link('新規登録はこちら', href: new_user_registration_path).click
      # ユーザー情報を入力しない
      fill_in 'user_nickname', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらない
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻されるか確認
      expect(current_path).to eq(user_registration_path)
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # ログインページに遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移しているか確認
      sleep(1)
      expect(current_path).to eq(root_path)
    end
  end
  context 'ログインできないとき' do
    it '保存されているユーザの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # ログインページに遷移していることを確認する
      expect(current_path).to eq(new_user_session_path)
      # ユーザー情報を入力しない
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻される
      expect(current_path).to eq(user_session_path)
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  it 'ログアウトができるとき' do
    # ログインする
    login_user(@user)
    # ログアウトボタンをクリックする
    find_link('ログアウト', href: destroy_user_session_path).click
    # ログインページへ遷移しているか確認
    expect(current_path).to eq(new_user_session_path)
  end
end
