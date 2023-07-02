class ItemsController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    @items = if params[:user_id]
               @user = User.find_by(id: params[:user_id])
               return render json: { error: 'User not found' }, status: :not_found unless @user

               @user.items
             else
               Item.includes(:user)
             end

    render json: @items, include: :user
  end

  def show
    @item = @user.items.find_by(id: params[:id])
    return render json: { error: 'Item not found' }, status: :not_found unless @item

    render json: @item
  end

  def create
    @user = User.find(params[:user_id])
    @item = @user.items.build(item_params)
  
    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end
  

  def update
    @item = @user.items.find_by(id: params[:id])
    return render json: { error: 'Item not found' }, status: :not_found unless @item

    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item = @user.items.find_by(id: params[:id])
    return render json: { error: 'Item not found' }, status: :not_found unless @item

    @item.destroy
    render json: { message: 'Item successfully deleted' }
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    return render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
  

end
