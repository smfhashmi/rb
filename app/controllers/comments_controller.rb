class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.order(created_at: :desc)
    @comment = Comment.new
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@comment, partial: 'comments/form', locals: {comment: @comment})
      end
    end
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
     if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_comment', partial: 'comments/form', locals: {comment: Comment.new}),
            turbo_stream.append('comments', partial: 'comments/comment', locals: {comment: @comment}),
            turbo_stream.update('comment_counter', html: "#{Comment.count}"),
            turbo_stream.update('notice', 'message created')
          ]
        end
        #format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
        #format.json { render :show, status: :created, location: @comment }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_comment', partial: 'comments/form', locals: {comment: @comment})
          ]
        end

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(@comment, partial: 'comments/comment', locals: {comment: @comment})
        }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(@comment, partial: 'comments/form', locals: {comment: @comment})
        }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@comment),
          turbo_stream.update('comment_counter', html: "#{Comment.count}")
        ]
      end
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:title, :body)
    end
end
