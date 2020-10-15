class SmallTargetsController < ApplicationController
  before_action :current_target, only: %i[new create]

  def new
    @small_target = SmallTarget.new
  end

  # def create
  #   is_achieved = true  if is_achieved?(params[:small_target][:happiness_grade], params[:small_target][:hardness_grade])
  #   @small_target = SmallTarget.new(small_target_params)
  #   if @small_target.save
  #     flash[:success] = "登録完了！"
  #     redirect_to target_path(@small_target)
  #   else
  #     flash[:error] = "登録失敗..."
  #     render :new
  #   end
  # end

  private

  # def small_target_params
  #   params.require(:habit).permit(:name, :content, :happiness_grade, :hardness_grade).merge(target: @target)
  # end

  # def is_achieved?(happiness_grade, hardness_grade)
  #   if happiness_grade != 0 && hardness_grade != 0
  #     return true
  #   else
  #     return -1
  #   end
  # end
  

  # habitsコントローラにも同様の記述あり
  def current_target
    @target = Target.find(params[:target_id])
  end
end
