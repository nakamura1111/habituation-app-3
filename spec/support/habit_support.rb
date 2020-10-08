module HabitSupport
  def visit_habit_new_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
    # 習慣の登録画面の遷移のリンクをクリックする
    find_link('鍛錬メニューを追加', href: new_target_habit_path(target)).click
  end

  def visit_habit_show_action(target, habit)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
    # 習慣の名前をクリックし、習慣詳細画面へ遷移する
    find_link(habit.name, href: target_habit_path(target, habit)).click
  end

  # 目標詳細ページに記載の目標達成状況の表が正しく反映されていることを確認するメソッド
  def confirm_achieved_status(achieved_or_not_binary)
    days = 7
    days.times do |i|
      display = if (achieved_or_not_binary >> (days - 1 - i) & 1) == 1
                  '〇'
                else
                  '×'
                end
      expect(all('tr.achieved-status-row th')[i]).to have_content(display)
    end
  end
end
