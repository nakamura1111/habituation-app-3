require 'rails_helper'

RSpec.describe '習慣の登録機能', type: :system do
  before do
    @habit = FactoryBot.build(:habit)
    @habit.target.save
  end
  context '習慣が登録できるとき' do
    it '習慣とその能力値名を入力したとき、登録される' do
      # ログインして、習慣登録ページに遷移
      visit_habit_new_action(@habit.target)
      # 習慣の登録フォームに入力する
      fill_in 'habit_name', with: @habit.name
      fill_in 'habit_content', with: @habit.content
      select Difficulty.find(@habit.difficulty_grade).name, from: 'habit[difficulty_grade]'
      # 登録ボタンを押すと、出品情報がDBに登録されることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Habit.count }.by(1)
      # 目標詳細表示画面に遷移していることを確認する
      expect(current_path).to eq(target_path(@habit.target))
    end
  end
  context '習慣が登録できないとき' do
    it '未ログインユーザは習慣の登録画面に遷移できない' do
      # 習慣の登録画面へ遷移する
      visit new_target_habit_path(@habit.target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインして、習慣登録ページに遷移
      visit_habit_new_action(@habit.target)
      # 習慣の登録フォームの入力
      fill_in 'habit_name', with: ''
      fill_in 'habit_content', with: ''
      # 登録ボタンを押しても、出品情報がDBに登録されていないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Habit.count }.by(0)
      # 習慣の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_habits_path(@habit.target))
    end
  end
end

RSpec.describe '習慣の達成チェック機能', type: :system do
  before(:each) do
    @habit = FactoryBot.create(:habit)
    @target = @habit.target
    @prev_point = 9
    @next_point = @prev_point + @habit.difficulty_grade + 1
    @target.update(point: @prev_point)
  end
  context '習慣達成の記録ができるとき' do
    it '目標詳細表示ページにて達成状況のクリックすると登録される' do
      # ログインして、目標の詳細ページに遷移
      visit_target_show_action(@target)
      # 今日の日付のクリックして、達成状況を更新する
      find("#achieved-check-cell-#{@habit.id}").click_link('達成したらチェック')
      # 目標詳細表示画面に遷移していることを確認する
      expect(current_path).to eq(target_path(@target))
      # 達成状況がDBとページに反映されていることを確認する
      @habit.reload
      expect(@habit.achieved_or_not_binary).to eq(1)
      expect(@habit.achieved_days).to eq(1)
      expect(all('tr.achieved-status-row th')[6]).to have_content('〇')
      # レベル・経験値がDBとページに反映されていることを確認する
      @target.reload
      expect(@target.point).to eq(@next_point)                               # point
      expect(find('.target-level').text).to eq('Lv. 2 - Level up!')          # level
      expect(find('.exp-bar')[:value].to_i).to eq(@habit.difficulty_grade)   # exp
    end
    it '習慣の詳細表示ページにて達成状況のクリックすると登録される' do
      # ログインして、習慣の詳細ページに遷移
      visit_habit_show_action(@target, @habit)
      # 今日の日付のクリックして、達成状況を更新する
      find("#achieved-check-cell-#{@habit.id}").click_link('達成したらチェック')
      # 習慣詳細表示画面に遷移していることを確認する
      expect(current_path).to eq(target_habit_path(@target, @habit))
      # 達成状況がDBとページに反映されていることを確認する
      @habit.reload
      expect(@habit.achieved_or_not_binary).to eq(1)
      expect(@habit.achieved_days).to eq(1)
      expect(all('tr.achieved-status-row th')[6]).to have_content('〇')
      # レベル・経験値がDBに反映されていることを確認する
      @target.reload
      expect(@target.point).to eq(@prev_point + @habit.difficulty_grade + 1) # point
      expect(@target.level).to eq(2)                                         # level
      expect(@target.exp).to eq(@habit.difficulty_grade)                     # exp
    end
  end
end

RSpec.describe '日付変更による達成状況を変更する機能', type: :system do
  before do
    @habit = FactoryBot.create(:habit)
    @target = @habit.target
    @achieved_or_not_binary = 0b101_0101
    @habit.update(achieved_or_not_binary: @achieved_or_not_binary)
  end
  context '日付変更による達成状況を変更することができるとき' do
    it '24:00に達成状況が変更される' do
      # ログインして、目標の詳細ページに遷移
      visit_target_show_action(@target)
      # 目標達成状況が正しく出力されていることを確認する
      confirm_achieved_status(@habit.achieved_or_not_binary)
      # 日付を跨ぐ
      time_now = Time.now
      travel_to Time.zone.local(time_now.year, time_now.mon, time_now.day + 1, 0, 0, 1) do
        # 目標達成状況が正しく反映されていることを確認する
        @habit.reload
        visit target_path(@target)
        confirm_achieved_status(@habit.achieved_or_not_binary)
      end
    end
  end
end

RSpec.describe '習慣の詳細表示機能', type: :system do
  before do
    @habit = FactoryBot.create(:habit)
  end
  context '習慣の詳細表示画面へ遷移できるとき' do
    it 'ログイン状態で遷移できる' do
      # ログインした上で、習慣の詳細ページへ遷移する
      visit_habit_show_action(@habit.target, @habit)
      # 無事遷移できていることを確認する
      expect(current_path).to eq(target_habit_path(@habit.target, @habit))
    end
  end
  context '習慣の詳細表示画面へ遷移できないとき' do
    it '未ログイン状態では遷移できない' do
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context '習慣の詳細表示画面で表示されるもの' do
    it '習慣について、表示すべき全ての情報が全て載っている' do
      # 達成状況、達成率の確認のため0以外の数値を入れておく
      days_of_habit_practice = 11
      time_of_habit_create = Time.now - ((days_of_habit_practice - 1) * 24 * 60 * 60)
      @habit.update(achieved_or_not_binary: Faker::Number.between(from: 1, to: (1 << 7) - 1), achieved_days: days_of_habit_practice, created_at: time_of_habit_create)
      # ログインした上で、習慣の詳細ページへ遷移する
      visit_habit_show_action(@habit.target, @habit)
      # 習慣内容、習慣達成率、習慣の難易度、達成状況、習慣の詳細内容が表示されていることを確認する
      habit_element = find('.habit-box')
      # 習慣の内容
      expect(habit_element.find('.habit-name')).to have_content(@habit.name)
      # 達成率
      expect(habit_element.find('.achieved-ratio-bar')).to have_attributes(value: '100')
      # 難易度
      expect(habit_element.find('.habit-difficulty').all('.star').length).to eq(@habit.difficulty_grade + 1)
      # 達成状況
      display_achieved_status(habit_element)
      # 習慣の詳細
      expect(habit_element.find('.habit-content-box')).to have_content(@habit.content)
    end
    it '達成率の違いで達成率のバーの色が異なる' do
      # 1 達成率100%
      p '100%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 1.0
      db_value_create_for_achieved_ratio(achieved_ratio)
      # ログインした上で、習慣の詳細ページへ遷移する
      visit_habit_show_action(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      habit_element = find('.habit-box')
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-success')
      # 2 達成率60%
      p '60%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 0.6
      db_value_create_for_achieved_ratio(achieved_ratio)
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-success')
      # 3 達成率50%
      p '50%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 0.5
      db_value_create_for_achieved_ratio(achieved_ratio)
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-warning')
      # 4 達成率20%
      p '20%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 0.2
      db_value_create_for_achieved_ratio(achieved_ratio)
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-warning')
      # 5 達成率10%
      p '10%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 0.1
      db_value_create_for_achieved_ratio(achieved_ratio)
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-error')
      # 6 達成率0%
      p '0%の場合'
      # 達成率の確認のため、数値を入れておく(入力数値: 0 から 1, 最小単位: 0.01)
      achieved_ratio = 0.0
      db_value_create_for_achieved_ratio(achieved_ratio)
      # 習慣の詳細ページへ遷移する
      visit target_habit_path(@habit.target, @habit)
      # 達成率のバーの色を確かめる
      p habit_element.find('.achieved-ratio-bar')[:value]
      expect(habit_element.find('.achieved-ratio-bar')[:class]).to have_content('is-error')
    end
    it '目標詳細ページへのリンクが踏める' do
      # ログインした上で、習慣の詳細ページへ遷移する
      visit_habit_show_action(@habit.target, @habit)
      # 目標詳細へのリンクが踏めることを確認する
      expect(page).to have_link('目標の詳細', href: target_path(@habit.target))
    end
  end
end
