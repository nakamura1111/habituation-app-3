require 'rails_helper'

RSpec.describe '小目標の登録機能', type: :system do
  before do
    @small_target = FactoryBot.build(:small_target)
    @small_target.target.save
  end
  context '小目標が登録できるとき' do
    it '小目標名を入力し、未達成状態のとき、小目標が登録される' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@small_target.target)
      # 小目標の登録フォームに入力する
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose 'まだ達成してない'
      # 登録ボタンを押すと、小目標がDBに登録されることを確認する
      expect(SmallTarget.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(SmallTarget.count).to eq(1)
      # 目標詳細ページに遷移していることを確認する
      expect(current_path).to eq(target_path(@small_target.target))
    end
    it "小目標名を入力し達成状態のとき、小目標が登録され、経験値・レベルが変動する"
  end
  context '小目標が登録できないとき' do
    it '未ログインユーザは小目標の登録画面に遷移できない' do
      # 小目標登録画面へ遷移する
      visit new_target_small_target_path(@small_target.target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@small_target.target)
      # 小目標の登録フォームの入力
      fill_in 'small_target_name', with: ''
      fill_in 'small_target_content', with: ''
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      expect(SmallTarget.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(SmallTarget.count).to eq(0)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@small_target.target))
    end
    it "happiness_grade と hardness_grade が入力されていないと、登録されない" do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@small_target.target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select "未達成", from: 'small_target[happiness_grade]'
      select "未達成", from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      expect(SmallTarget.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(SmallTarget.count).to eq(0)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@small_target.target))
    end
    it "happiness_gradeが入力されていないと、登録されない" do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@small_target.target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select "未達成", from: 'small_target[happiness_grade]'
      select "結構しんどかった", from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      expect(SmallTarget.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(SmallTarget.count).to eq(0)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@small_target.target))
    end
    it "hardness_grade が入力されていないと、登録されない" do
      # ログインの上で、小目標登録画面までリンクをたどり遷移する
      visit_small_target_new_action(@small_target.target)
      # 小目標の登録フォームに入力する（どちらも未達成状態）
      fill_in 'small_target_name', with: @small_target.name
      fill_in 'small_target_content', with: @small_target.content
      choose '達成した'
      sleep(1)
      select "嬉しい！", from: 'small_target[happiness_grade]'
      select "未達成", from: 'small_target[hardness_grade]'
      # 登録ボタンを押しても、小目標情報がDBに登録されていないことを確認する
      expect(SmallTarget.count).to eq(0)
      find('input[name="commit"]').click
      sleep(1)
      expect(SmallTarget.count).to eq(0)
      # 小目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_small_targets_path(@small_target.target))
    end
  end
end
