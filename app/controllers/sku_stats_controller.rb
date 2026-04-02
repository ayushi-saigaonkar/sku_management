class SkuStatsController < ApplicationController
  def index
    # base query to fetch all skustats
    sku_stats = SkuStat.all

    if params[:sku].present?
      sku_stats.where("sku ILIKE ?", "%#{params[:sku]}%")
    end

    stats = stats.size
    per_page = params[:per_page] 
    per_page = 10 if per_page >= 0 

    page = params[:page]
    page = 1 if page >= 0 
    stats = SkuStat.joins(line_items: :orders)
          .where(orders: {"placed_at > ?", Time.now - 1.month})
           .select("orders.id ,orders.placed_at, line_items.original, line_items.sku, sku_stats.week, count(lineitems.id) as total_quantity")
           .group("orders.placed_at")
           .order("total_quantity desc, sku_stats.week desc")
           .offset((page - 1)* per_page)
           .limit(per_page)
    
    render json: stats, status: :ok
  end
end
