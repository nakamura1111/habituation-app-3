class SmallTargetsController < ApplicationController
  before_action :current_target, only: %i[new create]

  def new
    @small_target = SmallTarget.new
  end

  def create
    # レコード作成
    @small_target = SmallTarget.new(small_target_params)
    # is_achieved カラムの設定
    if params[:small_target][:happiness_grade] == "0" && params[:small_target][:hardness_grade] == "0"
      @small_target.is_achieved = false
    elsif params[:small_target][:happiness_grade] != "0" && params[:small_target][:hardness_grade] != "0"
      @small_target.is_achieved = true
    else
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
    params.require(:small_target).permit(:name, :content, :happiness_grade, :hardness_grade).merge(target: @target)
  end

  # habitsコントローラにも同様の記述あり
  def current_target
    @target = Target.find(params[:target_id])
  end
end
