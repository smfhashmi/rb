class MessagesController < ApplicationController
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
    @message = get_message(params[:id])
    return @message
  end

  def edit
    @message = get_message(params[:id])
    render :edit
  end

  def update
    @message = get_message(params[:id])
    if @message.update(message_params)
      redirect_to messages_path
    else
      render :edit
    end
  end

  def destroy
    @message = get_message(params[:id])
    @message.destroy
    redirect_to messages_path
  end

  private

  def get_message(id)
    return Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:title, :description)
  end
end
