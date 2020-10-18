module SmallTargetSupport
  # 小目標の登録ページまで遷移する
  def visit_small_target_new_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へ遷移する
    find_link(target.name, href: target_path(target)).click
    # 小目標の登録画面の遷移のリンクをクリックする
    find_link('小目標・実績を追加', href: new_target_small_target_path(target)).click
  end

  # 登録ボタンをクリックし、DB保存がされるかどうかを記述()
  def click_for_small_target_registration(is_success)
    expect(SmallTarget.count).to eq(0)
    find('input[name="commit"]').click
    sleep(1)
    expect(SmallTarget.count).to eq(1) if is_success
    expect(SmallTarget.count).to eq(0) unless is_success
  end

  # 小目標の登録ページまで遷移する
  def visit_small_target_show_action(target, small_target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へ遷移する
    find_link(target.name, href: target_path(target)).click
    # 小目標をクリックし、小目標詳細表示画面へ遷移する
    find_link(small_target.name, href: target_small_target_path(target, small_target)).click
  end
end