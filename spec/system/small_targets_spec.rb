require 'rails_helper'

RSpec.describe '小目標の登録機能', type: :system do
  before(:each) do
    @small_target = FactoryBot.build(:small_target)
    @target = @small_target.target
    @target.save
    @next_point = @target.point + @small_target.happiness_grade + @small_target.hardness_grade
  end
  context '小目標が登録できるとき' do
    it '小目標名を入力し、未達成状態のとき、小目標が登録される' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose 'まだ達成してない'
      # 登録ボタンを押すと、小目標がDBに登録されることを確認する
      is_success = true
      click_for_small_target_registration(is_success)
      # 目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_path(@target))
      # Targetのポイント、経験値、レベルが反映されていないことを確認する
      @target.reload
      expect(@target.point).to eq(0)                             # point
      expect(find('.target-level').text).to eq('Lv. 1')          # level
      expect(find('.exp-bar')[:value].to_i).to eq(0)             # exp
    end
    it '小目標名を入力し、達成状況を入力した後未達成状態で小目標を登録したとき、未達成状態で小目標が登録される' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select '嬉しい！', from: 'small_target[happiness_grade]'
      select '心折れかけた...', from: 'small_target[hardness_grade]'
      choose 'まだ達成してない'
      # 登録ボタンを押すと、小目標がDBに登録されることを確認する
      is_success = true
      click_for_small_target_registration(is_success)
      # 目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_path(@target))
      # Targetのポイント、経験値、レベルが反映されていないことを確認する
      @target.reload
      expect(@target.point).to eq(0)                             # point
      expect(find('.target-level').text).to eq('Lv. 1')          # level
      expect(find('.exp-bar')[:value].to_i).to eq(0)             # exp
    end
    it '小目標名を入力し達成状態のとき、小目標が登録され、経験値・レベルが変動する' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select Happiness.where(id: @small_target.happiness_grade).sample.name, from: 'small_target[happiness_grade]'
      select Hardness.where(id: @small_target.hardness_grade).sample.name, from: 'small_target[hardness_grade]'
      # 登録ボタンを押すと、小目標がDBに登録されることを確認する
      is_success = true
      click_for_small_target_registration(is_success)
      # 目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_path(@target))
      # ページにTargetのポイント、経験値、レベルが反映されていることを確認する
      @target.reload
      expect(@target.point).to eq(@next_point)                                                                  # point
      expect(find('.target-level').text).to eq('Lv. 1')                                                         # level
      expect(find('.exp-bar')[:value].to_i).to eq(@small_target.happiness_grade + @small_target.hardness_grade) # exp
    end
  end
  context '小目標が登録できないとき' do
    it '未ログインユーザは小目標の登録画面に遷移できない' do
      # 小目標登録画面へ遷移する
      visit new_target_small_target_path(@target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームの入力
      fill_in 'small_target_name', with: ''
      fill_in 'small_target_content', with: ''
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      is_success = false
      click_for_small_target_registration(is_success)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@target))
      # ページにTargetのポイント、経験値、レベルが変わっていないことを確認する
      @target.reload
      expect(@target.point).to eq(0) # point
      expect(@target.level).to eq(1) # level
      expect(@target.exp).to eq(0)   # exp
    end
    it 'happiness_grade と hardness_grade が入力されていないと、登録されない' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select '未達成', from: 'small_target[happiness_grade]'
      select '未達成', from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      is_success = false
      click_for_small_target_registration(is_success)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@target))
    end
    it 'happiness_gradeが入力されていないと、登録されない' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select '未達成', from: 'small_target[happiness_grade]'
      select '結構しんどかった', from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      is_success = false
      click_for_small_target_registration(is_success)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@target))
    end
    it 'hardness_grade が入力されていないと、登録されない' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select '嬉しい！', from: 'small_target[happiness_grade]'
      select '未達成', from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      is_success = false
      click_for_small_target_registration(is_success)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@target))
    end
  end
  context '小目標の登録ページで表示されるもの' do
    it 'パンくずリストにて、「目標一覧へのリンク」「目標詳細表示へのリンク」「小目標登録ページであるという表示」がある' do
      target = @small_target.target
      # 小目標登録のページに遷移する
      visit_small_target_new_action(target)
      # 各種表示を確認する
      expect(page).to have_link("ユーザ：#{target.user.nickname}", href: root_path)
      expect(page).to have_link("目標：#{target.name}", href: target_path(target))
      expect(page).to have_content('小目標登録')
    end
  end
end

RSpec.describe '小目標の詳細表示機能', type: :system do
  before do
    @small_target = FactoryBot.create(:small_target)
  end
  context '小目標の詳細表示画面へ遷移できるとき' do
    it 'ログイン状態で遷移できる' do
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target)
      # 無事遷移できていることを確認する
      expect(current_path).to eq(target_small_target_path(@small_target.target, @small_target))
    end
  end
  context '小目標の詳細表示画面へ遷移できないとき' do
    it '未ログイン状態では遷移できない' do
      # 小目標の詳細ページへ遷移する
      visit target_small_target_path(@small_target.target, @small_target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context '小目標の詳細表示画面で表示されるもの' do
    it '達成状態の小目標について、表示すべき全ての情報が全て載っている' do
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target)
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていることを確認する
      small_target_element = find('.small-target-box')
      # 小目標の内容
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      # 嬉しさ
      expect(small_target_element.find('.small-target-happiness').all('.star').length).to eq(@small_target.happiness_grade)
      # 大変さ
      expect(small_target_element.find('.small-target-hardness').all('.star').length).to eq(@small_target.hardness_grade)
      # 小目標の詳細
      expect(small_target_element.find('.small-target-content-box')).to have_content(@small_target.content)
    end
    it '未達成状態の小目標について、表示すべき全ての情報が全て載っている' do
      # 小目標を未達成状態にする
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target)
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていることを確認する
      small_target_element = find('.small-target-box')
      # 小目標の内容
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      # 嬉しさ
      expect(small_target_element.find('.small-target-happiness').all('.is-empty').length).to eq(3)
      # 大変さ
      expect(small_target_element.find('.small-target-hardness').all('.is-empty').length).to eq(3)
      # 小目標の詳細
      expect(small_target_element.find('.small-target-content-box')).to have_content(@small_target.content)
    end
    it '目標詳細ページへのリンクが踏める' do
      # ログインした上で、小目標の詳細ページへ遷移する
      visit_small_target_show_action(@small_target)
      # 目標詳細へのリンクが踏めることを確認する
      expect(page).to have_link('目標の詳細', href: target_path(@small_target.target))
    end
    it 'パンくずリストにて、「目標一覧へのリンク」「目標詳細表示へのリンク」「小目標の詳細ページであるという表示」がある' do
      target = @small_target.target
      # 小目標詳細のページに遷移する
      visit_small_target_show_action(@small_target)
      # 各種表示を確認する
      expect(page).to have_link("ユーザ：#{target.user.nickname}", href: root_path)
      expect(page).to have_link("目標：#{target.name}", href: target_path(target))
      expect(page).to have_content("小目標：#{@small_target.name}")
    end
  end
end

RSpec.describe '小目標の編集機能', type: :system do
  before(:each) do
    @small_target = FactoryBot.create(:small_target)
    @target = @small_target.target
  end
  context '小目標が編集できるとき' do
    it '達成状況が false のままのとき登録される' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の編集フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      # 達成状況選択用のラヂオボタンがあることを確認する
      expect(all('input[name="small_target[is_achieved]"]').length).to eq(2)
      # 更新ボタンをクリックする
      click_for_small_target_update
      # 小目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の名前、詳細が反映されていることを確認する
      expect(find('.small-target-name').text).to have_content('編集後')
      expect(find('.small-target-content-box').text).to have_content('編集後')
      expect(find('.small-target-happiness').all('.is-empty').length).to eq(3)
      expect(find('.small-target-hardness').all('.is-empty').length).to eq(3)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
    it '達成状況を一時 true にし、達成状況を入力した後、再び false にすると、false 状態で登録される' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      choose '達成した'
      sleep(1)
      select '嬉しい！', from: 'small_target[happiness_grade]'
      select '心折れかけた...', from: 'small_target[hardness_grade]'
      choose 'まだ達成してない'
      # 更新ボタンをクリックする
      click_for_small_target_update
      # 小目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の名前、詳細が反映されていることを確認する
      expect(find('.small-target-name').text).to have_content('編集後')
      expect(find('.small-target-content-box').text).to have_content('編集後')
      expect(find('.small-target-happiness').all('.is-empty').length).to eq(3)
      expect(find('.small-target-hardness').all('.is-empty').length).to eq(3)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
    it '達成状況を false から true にすると、小目標が更新され、目標の経験値・レベルが変動する' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      choose '達成した'
      sleep(1)
      select '嬉しい！', from: 'small_target[happiness_grade]'
      select '心折れかけた...', from: 'small_target[hardness_grade]'
      # 登録ボタンを押すと、小目標がDBに登録されることを確認する
      click_for_small_target_update
      # 小目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の名前、詳細が反映されていることを確認する
      expect(find('.small-target-name').text).to have_content('編集後')
      expect(find('.small-target-content-box').text).to have_content('編集後')
      expect(find('.small-target-happiness').all('.star').length).to eq(2)
      expect(find('.small-target-hardness').all('.star').length).to eq(3)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(5)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(5)            # exp
    end
    it '達成状況が true のとき達成状況を操作することはできず、小目標が更新しても、目標の経験値・レベルが変動しない' do
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      # 達成状況選択用のラヂオボタンがないことを確認する
      expect(all('input[name="small_target[is_achieved]"]').length).to eq(0)
      # 変更ボタンを押す
      click_for_small_target_update
      # 小目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の名前、詳細が反映されていることを確認する
      expect(find('.small-target-name').text).to have_content('編集後')
      expect(find('.small-target-content-box').text).to have_content('編集後')
      expect(find('.small-target-happiness').all('.star').length).to eq(3)
      expect(find('.small-target-hardness').all('.star').length).to eq(1)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
  end
  context '小目標が編集できないとき' do
    it '未ログインユーザは小目標の編集画面に遷移できない' do
      # 小目標編集画面へ遷移する
      visit edit_target_small_target_path(@target, @small_target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容を空にした場合、更新できない' do
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームの入力
      fill_in 'small_target_name', with: ''
      fill_in 'small_target_content', with: ''
      # 更新ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      click_for_small_target_update
      # 小目標の編集画面に遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の名前、詳細が反映されていないことを確認する
      expect(find('#small_target_name').value).to have_content(@small_target.name)
      expect(find('#small_target_content').value).to have_content(@small_target.content)
      expect(find('.small-target-happiness').all('.star').length).to eq(3)
      expect(find('.small-target-hardness').all('.star').length).to eq(1)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
    it '達成状況を true にした後、happiness_grade と hardness_grade が入力されていないと、更新されない' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      choose '達成した'
      sleep(1)
      select '未達成', from: 'small_target[happiness_grade]'
      select '未達成', from: 'small_target[hardness_grade]'
      # 更新ボタンを押す
      click_for_small_target_update
      # 小目標の編集画面に遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていないことを確認する
      visit target_small_target_path(@target, @small_target)
      small_target_element = find('.small-target-box')
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      expect(small_target_element.find('.small-target-happiness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-hardness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-content-box')).to have_content(@small_target.content)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
    it '達成状況を true にした後、happiness_gradeが入力されていないと、更新されない' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      choose '達成した'
      sleep(1)
      select '未達成', from: 'small_target[happiness_grade]'
      select '心折れかけた...', from: 'small_target[hardness_grade]'
      # 更新ボタンを押す
      click_for_small_target_update
      # 小目標の編集画面に遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていないことを確認する
      visit target_small_target_path(@target, @small_target)
      small_target_element = find('.small-target-box')
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      expect(small_target_element.find('.small-target-happiness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-hardness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-content-box')).to have_content(@small_target.content)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
    it '達成状況を true にした後、hardness_grade が入力されていないと、更新されない' do
      # 達成状況を false にしておく
      @small_target.update(is_achieved: false, happiness_grade: 0, hardness_grade: 0)
      # ログインの上で、小目標編集画面までリンクをたどり遷移する
      visit_small_target_edit_action(@small_target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: '編集後'
      fill_in 'small_target_content', with: '編集後'
      choose '達成した'
      sleep(1)
      select '嬉しい！', from: 'small_target[happiness_grade]'
      select '未達成', from: 'small_target[hardness_grade]'
      # 更新ボタンを押す
      click_for_small_target_update
      # 小目標の編集画面に遷移していることを確認する
      expect(current_path).to eq(target_small_target_path(@target, @small_target))
      # 小目標の内容、嬉しさ、大変さ、小目標の詳細内容が表示されていないことを確認する
      visit target_small_target_path(@target, @small_target)
      small_target_element = find('.small-target-box')
      expect(small_target_element.find('.small-target-name')).to have_content(@small_target.name)
      expect(small_target_element.find('.small-target-happiness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-hardness').all('.is-empty').length).to eq(3)
      expect(small_target_element.find('.small-target-content-box')).to have_content(@small_target.content)
      # Targetのポイント、経験値、レベルが変化していないことを確認する
      @target.reload
      expect(@target.point).to eq(0)          # point
      expect(@target.level).to eq(1)          # level
      expect(@target.exp).to eq(0)            # exp
    end
  end
  context '小目標の編集ページで表示されるもの' do
    it 'パンくずリストにて、「目標一覧へのリンク」「目標詳細表示へのリンク」「小目標編集ページであるという表示」がある' do
      target = @small_target.target
      # 小目標編集のページに遷移する
      visit_small_target_edit_action(@small_target)
      # 各種表示を確認する
      expect(page).to have_link("ユーザ：#{target.user.nickname}", href: root_path)
      expect(page).to have_link("目標：#{target.name}", href: target_path(target))
      expect(page).to have_link("小目標：#{@small_target.name}", href: target_small_target_path(target, @small_target))
      expect(page).to have_content('小目標編集')
    end
  end
end
