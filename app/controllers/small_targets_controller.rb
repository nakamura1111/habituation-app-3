class SmallTargetsController < ApplicationController
  before_action :current_target, only: %i[new create]

  def new
    @small_target = SmallTarget.new
  end

  def create
    # レコード作成
    @small_target = SmallTarget.new(small_target_params)
    # 目標未達成時のデータ設定
    regist_happiness_and_hardness
    # 目標達成に対するデータバリデーション
    unless is_recorded_happiness_and_hardness
      flash[:error] = "登録失敗..."
      render :new
      return
    end
    # DB保存とリクエスト
    if @small_target.save
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

  # habitsコントローラにも同様の記述あり
  def current_target
    @target = Target.find(params[:target_id])
  end

  # happiness_gradeとhardness_gradeの加工
  def regist_happiness_and_hardness
    if @small_target.is_achieved == false
      @small_target.happiness_grade = 0
      @small_target.hardness_grade = 0
    end
  end

  # happiness_gradeとhardness_gradeのバリデーション（モデルに移動したほうがいいかな）
  def is_recorded_happiness_and_hardness
    
    binding.pry
    
    return false if @small_target.is_achieved == true && ( @small_target.happiness_grade == 0 || @small_target.hardness_grade == 0 )
    return true
  end
end
