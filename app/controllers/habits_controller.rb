# 習慣に関する機能を実装するためのコントローラー
class HabitsController < ApplicationController
  before_action :current_target, only: [:new, :create, :show]
  before_action :current_habit, only: [:update_achieved_status, :update_active_status, :show]
  before_action :move_to_target_show, only: :show

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
    if @habit.save
      flash[:success] = '鍛錬内容の登録完了'
      redirect_to target_path(@habit.target)
    else
      flash[:error] = '鍛錬内容の登録失敗'
      render :new
    end
  end

  # 習慣を今日達成した時にDBの情報を更新し、経験値を獲得する処理を行う
  def update_achieved_status
    if achieved_stat_update_tx(@habit)
      @habit.reload
      flash[:success] = '習慣の達成状況を更新しました'
      # channelを用いて、DBの変更をビューファイルに即時反映
      ActionCable.server.broadcast 'habits_achieved_status_channel', content: @habit
      ActionCable.server.broadcast 'targets_achieved_status_channel', content: @habit.target
    else
      flash[:error] = '習慣の達成状況を更新できませんでした(バグのため、作成者への問い合わせが必要)'
      redirect_to request.referer || root_path
    end
  end

  def show
    # 達成状況を 01 -> ×〇 に変換
    @achieved_status = Habit.translate_achieved_status(@habit.achieved_or_not_binary)
    # 達成率の算出
    @achieved_ratio = calc_achieved_ratio
  end

  # 習慣のアクティブ・非アクティブを変える処理を行う
  def update_active_status
    # 更新の際にactive_daysの日数を変更する(アクティブ状態が変更していて、今日習慣が達成されていない場合)
    active_days_tmp = modify_active_days
    # 更新
    if @habit.update(is_active: params[:is_active], active_days: active_days_tmp)
      flash[:success] = '習慣の状態を更新しました'
      redirect_to request.referer || root_path
    else
      flash[:error] = '習慣の達成状況を更新できませんでした(バグのため、作成者への問い合わせが必要)'
      redirect_to root_path
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :content, :difficulty_grade).merge(target: @target, achieved_or_not_binary: 0, achieved_days: 0, is_active: true)
  end

  # small_targetsコントローラにも同様の記述あり
  def current_target
    @target = Target.find(params[:target_id])
  end

  def current_habit
    @habit = Habit.find(params[:id])
  end

  # 達成状況と能力値の変動をDBに記録するメソッド
  def achieved_stat_update_tx(habit)
    ActiveRecord::Base.transaction do
      is_add = habit.achieved_or_not_binary & 1 # Targetのpointが増えるかどうかを判定
      raise ActiveRecord::Rollback unless habit.update(achieved_or_not_binary: habit.achieved_or_not_binary | 1, achieved_days: habit.achieved_days + 1)
      raise ActiveRecord::Rollback unless Target.add_point_by_habit_achieve(habit, is_add)

      return true
    end
  end

  # アクティブ状態の変更に伴い日数を変更するメソッド
  def modify_active_days
    # アクティブ状態に切り替える かつ 今日、該当習慣を達成していない場合、日数を一日増やす
    if @habit.is_active == false && params[:is_active] == 'true' && (@habit.achieved_or_not_binary & 1).zero?
      @habit.active_days + 1
    # 非アクティブ状態に切り替える かつ 今日、該当習慣を達成していない場合、日数を一日減らす
    elsif @habit.is_active == true && params[:is_active] == 'false' && (@habit.achieved_or_not_binary & 1).zero?
      @habit.active_days - 1
    else
      @habit.active_days
    end
  end

  # アクティブ状態が偽のとき、特定のページを表示させないためのメソッド
  def move_to_target_show
    redirect_to target_path(@target) if @habit.is_active == false
  end

  # 達成率を算出するメソッド
  def calc_achieved_ratio
    achieved_ratio = @habit.achieved_days.to_f / @habit.active_days * 100
    achieved_ratio = 0 if achieved_ratio.nil?
    achieved_ratio.to_i
  end
end
