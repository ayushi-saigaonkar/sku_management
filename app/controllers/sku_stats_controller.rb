class SkuStatsController < ApplicationController
  def index
    # base query to fetch all skustats
    sku_stats = SkuStat.all

    if params[:sku].present?
      sku_stats.where("sku ILIKE ?", "%#{params[:sku]}%")
    end

    per_page = params[:per_page]
    per_page = 10 if per_page <= 0

    page = params[:page]
    page = 1 if page <= 0

    sku_stats = sku_stats
                  .order(week: :desc)
                  .offset((page - 1) * per_page)
                  .limit(per_page)

    render json: stats, status: :ok
  end
end
