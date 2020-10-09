require 'rails_helper'

RSpec.describe SmallTarget, type: :model do
  describe 'バリデーション' do
    before do
      @small_target = FactoryBot.build(:small_target)
    end
    context '小目標名(name)が登録できないとき' do
      it '空だと登録できない' do
        @small_target.name = ''
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('小目標名を入力してください')
      end
      it '51文字以上だと登録できない' do
        @small_target.name = Faker::Lorem.paragraph_by_chars(number: 51)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('小目標名は50文字以内で入力してください')
      end
    end
    context '詳細内容(content)が登録できないとき' do
      it '501文字以上だと登録できない' do
        @small_target.content = Faker::Lorem.paragraph_by_chars(number: 501)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('詳細内容は500文字以内で入力してください')
      end
    end
    context '達成時の嬉しさ(happiness_grade)が登録できないとき' do
      it '空だと登録できない' do
        @small_target.happiness_grade = ''
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成時の嬉しさを入力してください')
      end
      it '数値以外は登録できない' do
        @small_target.happiness_grade = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成時の嬉しさは数値で入力してください')
      end
      it '整数以外は登録できない' do
        @small_target.happiness_grade = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成時の嬉しさは整数で入力してください')
      end
    end
    context '達成までの大変さ(hardness_grade)が登録できないとき' do
      it '空だと登録できない' do
        @small_target.hardness_grade = ''
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成までの大変さを入力してください')
      end
      it '数値以外は登録できない' do
        @small_target.hardness_grade = Faker::Alphanumeric.alphanumeric(number: 4, min_alpha: 1)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成までの大変さは数値で入力してください')
      end
      it '整数以外は登録できない' do
        @small_target.hardness_grade = Faker::Number.decimal(l_digits: 3, r_digits: 1)
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('達成までの大変さは整数で入力してください')
      end
    end
    context '達成済みか否かの判断フラグ(is_achieved)が登録できないとき' do
      it '空だと登録できない' do
        @small_target.is_achieved = ''
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('Is achievedは一覧にありません')
      end
    end
    context '目標(Targetモデル)のidが登録できないとき' do
      it 'Targetが紐づいていないと登録できない' do
        @small_target.target = nil
        @small_target.valid?
        expect(@small_target.errors.full_messages).to include('Targetを入力してください')
      end
    end
    context '登録できるとき' do
      it '詳細内容(content)が空でも登録できる' do
        @small_target.content = ''
        expect(@small_target).to be_valid
      end
      it '達成済みか否かの判断フラグ(is_achieved)が true か false なら登録できる' do
        @small_target.is_achieved = true
        expect(@small_target).to be_valid
        @small_target.is_achieved = false
        expect(@small_target).to be_valid
      end
      it '達成済みか否かの判断フラグ(is_achieved)が1以上の数値ならtrueとして, 0ならばfalseとして登録できる' do
        @small_target.is_achieved = 0
        expect(@small_target).to be_valid
        expect(@small_target.is_achieved).to eq(false)
        @small_target.is_achieved = Faker::Number.number(digits: 3)
        expect(@small_target).to be_valid
        expect(@small_target.is_achieved).to eq(true)
      end
      it '正常に入力していれば登録できる' do
        expect(@small_target).to be_valid
      end
    end
  end
end
