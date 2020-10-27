module TargetSupport
  # 目標の詳細表示への遷移をする
  def visit_target_show_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
  end

  # 目標登録ページへ遷移する
  def visit_target_new_action(user)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(user)
    # 目標登録画面へ遷移する
    find_link('目標を設定', href: new_target_path).click
  end

  # 達成状況を表す表に正しく値が格納されているか調べる
  def display_achieved_status(habit_element)
    date_element = habit_element.all('.date-row th') #  日付表示をしている行の各セルの要素を取り出す
    achieved_status_element = habit_element.all('.achieved-status-row th') #  達成状況を表示している行の各セルの要素を取り出す
    display_days_m1 = 6 # 表示日数を変数に格納
    (display_days_m1..0).each do |i|
      # 日付の入力を確認する
      expect(date_element).to have_content(Date.today - i)
      # 達成状況の入力を確認する
      if (@habit.achieved_or_not_binary >> i) & 1 == 1
        expect(achieved_status_element[display_days_m1 - i]).to have_content('〇')
      else
        expect(achieved_status_element[display_days_m1 - i]).to have_content('×')
      end
    end
  end
end
