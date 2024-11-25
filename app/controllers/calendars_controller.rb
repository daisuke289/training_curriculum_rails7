class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_Week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    def create
      Plan.create(plan_params)
      redirect_to action: :index
    end
  end

  private

  # ストロングパラメータ
  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_Week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)'] # 曜日配列
  
    @todays_date = Date.today # 今日の日付を取得
    @week_days = [] # 1週間の日付情報を格納する配列
  
    plans = Plan.where(date: @todays_date..@todays_date + 6) # 今日から1週間分の予定を取得
  
    7.times do |x|
      # 今日からx日後の日付に対応する予定を取得
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
 
      # 曜日を計算し、days ハッシュに追加
      days = {
        month: (@todays_date + x).month,          # 月
        date: (@todays_date + x).day,            # 日
        plans: today_plans,                      # 予定
        wday: wdays[(@todays_date + x).wday]     # 曜日
      }
  
      # days を @week_days 配列に追加
      @week_days.push(days)
    end
  end
end