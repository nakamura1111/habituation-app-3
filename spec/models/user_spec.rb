require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  describe 'バリデーション' do
    context 'nicknameが登録できないとき' do
      it '空だと登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end
    end
    context 'emailが登録できないとき' do
      it '空だと登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスを入力してください')
      end
      it '「@」がないと登録できない' do
        @user.email = 'sample_sample.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスの入力を確認してください')
      end
      it '一意性制約に反すると登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('メールアドレスはすでに存在します')
      end
    end
    context 'passwordが登録できないとき' do
      it 'passwordが空だと登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end
      it 'passwordが6文字以下だと登録できない' do
        @user.password = Faker::Alphanumeric.alphanumeric(number: 6, min_alpha: 1, min_numeric: 1)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードの入力を確認してください')
      end
      it 'passwordが半角アルファベットのみだと登録できない' do
        @user.password = Faker::Alphanumeric.alpha(number: 7)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードの入力を確認してください')
      end
      it 'passwordが半角数字のみだと登録できない' do
        @user.password = Faker::Number.number(digits: 7)
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードの入力を確認してください')
      end
      it 'password_confirmationが空だと登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'password_confirmationがpasswordと一致していないと登録できない' do
        @user.password = "#{@user.password}hoge"
        @user.password_confirmation = "#{@user.password}fuga"
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
    end
    context '登録できるとき' do
      it '条件に合う入力を行っていれば登録できる' do
        expect(@user).to be_valid
        users = FactoryBot.create_list(:user, 10)
        users.each { |user| expect(user).to be_valid }
      end
    end
  end
end
