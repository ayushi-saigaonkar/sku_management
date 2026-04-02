class CalculateSkuStatsJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(id: params[:order_id])
    CalculateSkuStats.new(order).call
    Rails.logger.info "perform recalculation for skustats"
  end
end
