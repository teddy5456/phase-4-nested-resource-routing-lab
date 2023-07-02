class UsersController < ApplicationController
  def show
    user = User.includes(:items).find(params[:id])
    render json: user, include: [:items]
  end
end