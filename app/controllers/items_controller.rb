class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items, except: [:created_at, :updated_at] 
    else
      items = Item.all
      render json: items, except: [:created_at, :updated_at], include: :user
    end
  end


  def show
    items = Item.find(params[:id])
    render json: items, except: [:created_at, :updated_at] 
  end

  def create
    user = User.find(params[:user_id])
    new_item = user.items.create(item_params)
    render json: new_item, status: :created
  end
  
  
  private
  def render_not_found_response
     render json: {error: "Not found"}, status: :not_found 
  end
  
  def item_params
      params.permit(:name, :description, :price, :user_id)
    end


end
