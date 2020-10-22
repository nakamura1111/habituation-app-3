class SmallTargetsController < ApplicationController
  before_action :current_target, only: %i[new create show edit update]
  before_action :current_small_target, only: %i[show edit update]

  def new
    @small_target = SmallTarget.new
  end

  def create
    if params[:small_target][:is_achieved] == 'false'
      params[:small_target][:happiness_grade] = 0
      params[:small_target][:hardness_grade] = 0
    end
    # レコード作成
    @small_target = SmallTarget.new(small_target_params)
    # # 目標未達成時のデータ設定
    # @small_target.mod_happiness_and_hardness
    # SmallTarget, TargetモデルへのDB保存とリクエスト
    if create_transaction(@small_target)
      flash[:success] = '登録完了！'
      redirect_to target_path(@target)
    else
      flash[:error] = '登録失敗...'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    params_tmp = small_target_params
    if params_tmp[:is_achieved].nil?
      params_tmp[:is_achieved] = true
      params_tmp[:happiness_grade] = @small_target.happiness_grade
      params_tmp[:hardness_grade] = @small_target.hardness_grade
    elsif params_tmp[:is_achieved] == 'false'
      params_tmp[:happiness_grade] = 0
      params_tmp[:hardness_grade] = 0
    end
    @small_target_update = SmallTarget.new(params_tmp)
    # SmallTarget, TargetモデルへのDB保存とリクエスト
    if update_transaction(@small_target, @small_target_update)
      flash[:success] = '登録完了！'
      redirect_to target_small_target_path(@target, @small_target), action: :show
    else
      flash[:error] = '登録失敗...'
      current_small_target
      render :edit
    end
  end

  private

  def small_target_params
    params.require(:small_target).permit(:name, :content, :happiness_grade, :hardness_grade, :is_achieved).merge(target: @target)
  end

  def small_target_params_update(small_target)
    { name: small_target.name, content: small_target.content, happiness_grade: small_target.happiness_grade,
      hardness_grade: small_target.hardness_grade, is_achieved: small_target.is_achieved, target: small_target.target }
  end

  def current_target
    @target = Target.find(params[:target_id])
  end

  def current_small_target
    @small_target = SmallTarget.find(params[:id])
  end

  # # happiness_gradeとhardness_gradeの加工
  # def mod_happiness_and_hardness
  #   if @small_target.is_achieved == false
  #     @small_target.happiness_grade = 0
  #     @small_target.hardness_grade = 0
  #   end
  # end

  # # happiness_gradeとhardness_gradeのバリデーション（モデルに移動したほうがいいかな）
  # def recorded_happiness_and_hardness?
  #   return false if @small_target.is_achieved == true && ( @small_target.happiness_grade == 0 || @small_target.hardness_grade == 0 )
  #   return true
  # end

  # 小目標の達成状況と能力値の変動をDBに記録するメソッド
  def create_transaction(small_target)
    ActiveRecord::Base.transaction do
      # 目標達成に対するデータバリデーション
      raise ActiveRecord::Rollback unless small_target.recorded_happiness_and_hardness?
      # 小目標のDB保存
      raise ActiveRecord::Rollback unless small_target.save
      # 目標の経験値・レベルのDB保存
      raise ActiveRecord::Rollback unless Target.add_point_by_small_target_achieve(small_target)

      return true
    end
  end

  # 小目標の達成状況と能力値の変動を更新するメソッド
  def update_transaction(small_target, small_target_update)
    ActiveRecord::Base.transaction do
      prev_achieved = small_target.is_achieved
      next_achieved = small_target_update.is_achieved
      # 未達成への更新は不可
      raise ActiveRecord::Rollback if prev_achieved == true && next_achieved == false
      # 目標達成に対するデータバリデーション
      raise ActiveRecord::Rollback unless small_target_update.recorded_happiness_and_hardness?
      # 小目標のDB保存
      raise ActiveRecord::Rollback unless small_target.update(small_target_params_update(small_target_update))

      # 目標の経験値・レベルのDB保存
      if prev_achieved == false && next_achieved == true
        raise ActiveRecord::Rollback unless Target.add_point_by_small_target_achieve(small_target_update)
      end

      return true
    end
  end
end
