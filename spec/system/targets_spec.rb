require 'rails_helper'

RSpec.describe '目標の登録機能', type: :system do
  before do
    @target = FactoryBot.build(:target)
    @target.user.save
  end
  context '目標が登録できるとき' do
    it '目標とその能力値名を入力したとき、登録される' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
      # 目標登録画面へ遷移する
      find_link('目標を設定', href: new_target_path).click
      # 目標の登録フォームに入力する
      fill_in 'target_content', with: @target.content
      fill_in 'target_name', with: @target.name
      # 登録ボタンを押すと、出品情報がDBに登録されることを確認する
      expect(Target.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(Target.count).to eq(1)
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
  end
  context '目標が登録できないとき' do
    it '未ログインユーザは目標の登録画面に遷移できない' do
      # 目標登録画面へ遷移する
      visit new_target_path
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
      # 目標登録画面へ遷移する
      find_link('目標を設定', href: new_target_path).click
      sleep(1)
      # 目標の登録フォームの入力
      fill_in 'target_content', with: ''
      fill_in 'target_name', with: ''
      # 登録ボタンを押しても、出品情報がDBに登録されていないことを確認する
      expect(Target.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(Target.count).to eq(0)
      # 目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(targets_path)
    end
  end
end

RSpec.describe '目標の一覧機能', type: :system do
  before do
    @target = FactoryBot.create(:target)
  end
  context '目標一覧が見られるとき' do
    it 'ログインしている場合、自分の目標一覧に遷移できる' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
    end
  end
  context '目標一覧が見られないとき' do
    it '未ログインユーザは目標一覧には遷移できない' do
      # トップページに遷移する
      visit root_path
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context '表示されているもの' do
    it '目標一覧には、能力値名・レベル・経験値が表示されている' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
      # 表示されていることを確認
      target_element = find('.target-box')
      expect(target_element).to have_content(@target.name)
      expect(target_element).to have_content("Lv. #{@target.level}")
      expect(target_element.find('.nes-progress')).to have_attributes(value: @target.exp.to_s)
    end
  end
end

RSpec.describe '目標の詳細表示機能', type: :system do
  before do
    @habit = FactoryBot.create(:habit)
    @small_target = FactoryBot.build(:small_target)
    @small_target.target = @habit.target
    @small_target.save
  end
  context '目標の詳細表示画面へ遷移できるとき' do
    it 'ログイン状態で遷移できる' do
      # ログインした上で、目標の詳細ページへ遷移する
      visit_target_show_action(@habit.target)
      # 無事遷移できていることを確認する
      expect(current_path).to eq(target_path(@habit.target))
    end
  end
  context '目標の詳細表示画面へ遷移できないとき' do
    it '未ログイン状態では遷移できない' do
      # 目標の詳細ページへ遷移する
      visit target_path(@habit.target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context '目標の詳細表示画面で表示されるもの' do
    it '目標について、表示すべき全ての情報が全て載っている' do
      # ログインした上で、目標の詳細ページへ遷移する
      target = @habit.target
      visit_target_show_action(target)
      # 能力値名、レベル、経験値、目標が表示されていることを確認する
      target_element = find('.target-box')
      expect(target_element.find('h3.target-name')).to have_content(target.name)
      expect(target_element.find('.target-level')).to have_content("Lv. #{target.level}")
      expect(target_element.find('.nes-progress')).to have_attributes(value: target.exp.to_s)
      expect(target_element.find('.target-content-box')).to have_content(target.content)
    end
    it '習慣の内容について、一部の情報が載っている' do
      # 達成状況確認のため0以外の数値を入れておく
      @habit.update(achieved_or_not_binary: Faker::Number.between(from: 1, to: (1 << 7) - 1))
      # ログインした上で、目標の詳細ページへ遷移する
      visit_target_show_action(@habit.target)
      # 鍛錬内容、難易度、達成状況が表示されていることを確認する
      # 鍛錬内容
      habit_element = find('.habit-box')
      expect(habit_element.find('h3.title')).to have_content(@habit.name)
      # 難易度
      expect(habit_element.text).to have_content("難易度：#{Difficulty.find(@habit.difficulty_grade).name}")
      # 達成状況
      display_achieved_status(habit_element)
    end
    it '未達成の小目標について、一部情報が載っている' do
      # 小目標を未達成状態にする
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target.target, @small_target)
      # 小目標の内容、嬉しさ、大変さが表示されていることを確認する
      small_target_element = find('.small-target-box')
      # 小目標の内容
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      # 嬉しさ
      expect(small_target_element.find('.small-target-happiness').all('.is-empty').length).to eq(3)
      # 大変さ
      expect(small_target_element.find('.small-target-hardness').all('.is-empty').length).to eq(3)
    end
    it '達成済みの小目標について、一部情報が載っている' do
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target.target, @small_target)
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていることを確認する
      small_target_element = find('.small-target-box')
      # 小目標の内容
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      # 嬉しさ
      expect(small_target_element.find('.small-target-happiness').all('.star').length).to eq(@small_target.happiness_grade)
      # 大変さ
      expect(small_target_element.find('.small-target-hardness').all('.star').length).to eq(@small_target.hardness_grade)
    end
    it '習慣登録と目標一覧のリンクが踏める' do
      # ログインした上で、目標の詳細ページへ遷移する
      target = @habit.target
      visit_target_show_action(target)
      # 習慣登録と目標一覧のリンクが踏めることを確認する
      expect(page).to have_link('鍛錬メニューを追加', href: new_target_habit_path(target))
      expect(page).to have_link('目標の一覧', href: targets_path)
    end
  end
end
