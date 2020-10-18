class SmallTargetsController < ApplicationController
  before_action :current_target, only: %i[new create]

  def new
    @small_target = SmallTarget.new
  end

  def create
    # レコード作成
    @small_target = SmallTarget.new(small_target_params)
    # 目標未達成時のデータ設定
    @small_target.regist_happiness_and_hardness
    # SmallTarget, TargetモデルへのDB保存とリクエスト
    if create_transaction(@small_target)
      flash[:success] = "登録完了！"
      redirect_to target_path(@target)
    else
      flash[:error] = "登録失敗..."
      render :new
    end
  end

  private

  def small_target_params
    params.require(:small_target).permit(:name, :content, :happiness_grade, :hardness_grade, :is_achieved).merge(target: @target)
  end

  def current_target
    @target = Target.find(params[:target_id])
  end

  # # happiness_gradeとhardness_gradeの加工
  # def regist_happiness_and_hardness
  #   if @small_target.is_achieved == false
  #     @small_target.happiness_grade = 0
  #     @small_target.hardness_grade = 0
  #   end
  # end

  # # happiness_gradeとhardness_gradeのバリデーション（モデルに移動したほうがいいかな）
  # def is_recorded_happiness_and_hardness
  #   return false if @small_target.is_achieved == true && ( @small_target.happiness_grade == 0 || @small_target.hardness_grade == 0 )
  #   return true
  # end

  # 小目標の達成状況と能力値の変動をDBに記録するメソッド
  def create_transaction(small_target)
    ActiveRecord::Base.transaction do
      # 目標達成に対するデータバリデーション
      raise ActiveRecord::Rollback unless small_target.is_recorded_happiness_and_hardness
      # 小目標のDB保存
      raise ActiveRecord::Rollback unless small_target.save
      # 目標の経験値・レベルのDB保存
      raise ActiveRecord::Rollback unless Target.add_point_by_small_target_achieve(small_target)
      return true
    end
  end
end
