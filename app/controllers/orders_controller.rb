class OrdersController < ApplicationController
  def create
    # fetch new order params
    order = Order.new(order_params)

    # check if any existing order has same external_id
    # if yes -- check if order is lock and created_at > 15mins
    # if no - mark previous order's lineitems original false
    existing_order = Order.find(external_id: params[:external_id])

    if existing_order.present? & existing_order.locked_at.present? && existing_order.created_at > (Time.now - 15.minutes)
      render json: { error: "Unprocessed Entity" }, status: 422
    else
      existing_order.line_items.update_all(original: false)
      order.line_items.update_all(original: true)
    end

    # save new original
    if order.save
      CalculateSkuStatsJob.perform_later(order.id)
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def lock
    order = Order.find(id: params[:id])
    order.locked_at = Time.now() # can use Time.current()
    CalculateSkuStatsJob.perform_later(order.id)
  end

  private

  def order_params
    params.permit(:external_id, :placed_at, :line_items)
  end
end
