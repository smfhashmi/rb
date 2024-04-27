class MessagesController < ApplicationController
  before_action :get_message, only: [:show, :edit, :update, :destroy]
  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to messages_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    render :edit
  end

  def update
    if @message.update(message_params)
      redirect_to messages_path
    else
      render :edit
    end
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  private

  def get_message(id)
    @message = Message.find(params[:id])
    return @message
  end

  def message_params
    params.require(:message).permit(:title, :description)
  end
end
