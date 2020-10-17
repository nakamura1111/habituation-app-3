module SmallTargetSupport
  def visit_small_target_new_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
    # 小目標の登録画面の遷移のリンクをクリックする
    find_link('小目標・実績を追加', href: new_target_small_target_path(target)).click
  end
end