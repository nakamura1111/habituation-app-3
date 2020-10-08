require 'rails_helper'

RSpec.describe Target, type: :model do
  describe 'バリデーション' do
    before do
      @target = FactoryBot.build(:target)
    end
    context 'パラメータ名を登録できない' do
      it '空だと登録できない' do
        @target.name = ''
        @target.valid?
        expect(@target.errors.full_messages).to include('パラメータ名を入力してください')
      end
      it '21文字以上だと登録できない' do
        @target.name = Faker::Lorem.paragraph_by_chars(number: 21)
        @target.valid?
        expect(@target.errors.full_messages).to include('パラメータ名は20文字以内で入力してください')
      end
    end
    context '目標を登録できない' do
      it '空だと登録できない' do
        @target.content = ''
        @target.valid?
        expect(@target.errors.full_messages).to include('達成目標を入力してください')
      end
      it '501文字以上だと登録できない' do
        @target.content = Faker::Lorem.paragraph_by_chars(number: 501)
        @target.valid?
        expect(@target.errors.full_messages).to include('達成目標は500文字以内で入力してください')
      end
    end
    context '点数(レベルと経験値を算出するための要素)を登録できない' do
      it '空だと登録できない' do
        @target.point = ''
        @target.valid?
        expect(@target.errors.full_messages).to include('Pointを入力してください')
      end
      it '数値以外は登録できない' do
        @target.point = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Pointは数値で入力してください')
      end
      it '整数以外は登録できない' do
        @target.point = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Pointは整数で入力してください')
      end
    end
    context '能力レベルを登録できない' do
      it '空だと登録できない' do
        @target.level = ''
        @target.valid?
        expect(@target.errors.full_messages).to include('Levelを入力してください')
      end
      it '数値以外は登録できない' do
        @target.level = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Levelは数値で入力してください')
      end
      it '整数以外は登録できない' do
        @target.level = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Levelは整数で入力してください')
      end
    end
    context '経験値を登録できない' do
      it '空だと登録できない' do
        @target.exp = ''
        @target.valid?
        expect(@target.errors.full_messages).to include('Expを入力してください')
      end
      it '数値以外は登録できない' do
        @target.exp = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Expは数値で入力してください')
      end
      it '整数以外は登録できない' do
        @target.exp = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @target.valid?
        expect(@target.errors.full_messages).to include('Expは整数で入力してください')
      end
    end
    context 'ユーザを登録できないとき' do
      it 'ユーザが紐づいていないと登録できない' do
        @target.user = nil
        @target.valid?
        expect(@target.errors.full_messages).to include('Userを入力してください')
      end
    end
    context '登録できるとき' do
      it '正常な値ならば登録できる' do
        expect(@target).to be_valid
      end
    end
  end
end
