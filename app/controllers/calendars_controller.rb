class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    begin
      Plan.create(plan_params)
      redirect_to action: :index
    rescue ActionController::ParameterMissing
      # パラメータ不足時の処理
      redirect_to action: :index, alert: '不正なパラメータが送信されました。'
    end
  end

  private

  # ストロングパラメータ
  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    @todays_date = Date.today
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      days = {
        month: (@todays_date + x).month,
        date: (@todays_date + x).day,
        plans: today_plans
      }
      @week_days.push(days)
    end
  end
end