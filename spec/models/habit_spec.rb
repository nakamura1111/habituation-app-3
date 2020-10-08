require 'rails_helper'

RSpec.describe Habit, type: :model do
  describe 'バリデーション' do
    before do
      @habit = FactoryBot.build(:habit)
    end
    context '習慣名(name)が登録できないとき' do
      it '空だと登録できない' do
        @habit.name = ''
        @habit.valid?
        expect(@habit.errors.full_messages).to include('鍛錬内容（習慣）を入力してください')
      end
      it '51文字以上だと登録できない' do
        @habit.name = Faker::Lorem.paragraph_by_chars(number: 51)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('鍛錬内容（習慣）は50文字以内で入力してください')
      end
    end
    context '詳細内容(content)が登録できないとき' do
      it '501文字以上だと登録できない' do
        @habit.content = Faker::Lorem.paragraph_by_chars(number: 501)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('詳細内容は500文字以内で入力してください')
      end
    end
    context '難易度(difficulty_grade)が登録できないとき' do
      it '空だと登録できない' do
        @habit.difficulty_grade = ''
        @habit.valid?
        expect(@habit.errors.full_messages).to include('難易度を入力してください')
      end
      it '数値以外は登録できない' do
        @habit.difficulty_grade = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('難易度は数値で入力してください')
      end
      it '整数以外は登録できない' do
        @habit.difficulty_grade = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('難易度は整数で入力してください')
      end
    end
    context '達成状況(achieved_or_not_binary)が登録できないとき' do
      it '空だと登録できない' do
        @habit.achieved_or_not_binary = ''
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成状況を入力してください')
      end
      it '数値以外は登録できない' do
        @habit.achieved_or_not_binary = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成状況は数値で入力してください')
      end
      it '整数以外は登録できない' do
        @habit.achieved_or_not_binary = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成状況は整数で入力してください')
      end
    end
    context '達成日数(achieved_days)が登録できないとき' do
      it '空だと登録できない' do
        @habit.achieved_days = ''
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成日数を入力してください')
      end
      it '数値以外は登録できない' do
        @habit.achieved_days = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成日数は数値で入力してください')
      end
      it '整数以外は登録できない' do
        @habit.achieved_days = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成日数は整数で入力してください')
      end
      it '1_000_000_000以上は登録できない' do
        @habit.achieved_days = 1_000_000_000
        @habit.valid?
        expect(@habit.errors.full_messages).to include('達成日数は1000000000より小さい値にしてください')
      end
    end
    context '習慣の有効化(is_active)が登録できないとき' do
      it '空だと登録できない' do
        @habit.is_active = ''
        @habit.valid?
        expect(@habit.errors.full_messages).to include('Is activeは一覧にありません')
      end
    end
    context '目標(Targetモデル)のidが登録できないとき' do
      it 'Targetが紐づいていないと登録できない' do
        @habit.target = nil
        @habit.valid?
        expect(@habit.errors.full_messages).to include('Targetを入力してください')
      end
    end
    context '登録できるとき' do
      it '詳細内容(content)が空でも登録できる' do
        @habit.content = ''
        expect(@habit).to be_valid
      end
      it '習慣の有効化(is_active)が true か false なら登録できる' do
        @habit.is_active = true
        expect(@habit).to be_valid
        @habit.is_active = false
        expect(@habit).to be_valid
      end
      it '習慣の有効化(is_active)が1以上の数値ならtrueとして, 0ならばfalseとして登録できる' do
        @habit.is_active = 0
        expect(@habit).to be_valid
        expect(@habit.is_active).to eq(false)
        @habit.is_active = Faker::Number.number(digits: 3)
        expect(@habit).to be_valid
        expect(@habit.is_active).to eq(true)
      end
      it '正常に入力していれば登録できる' do
        expect(@habit).to be_valid
      end
    end
  end
end
