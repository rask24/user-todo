class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def index
    unless user_signed_in?
      authenticate_user!
    end
    # @tasks = Task.order(:created_at)
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(title: task_params[:title], user_id: current_user[:id])
    puts '+++++++++++++++++'
    p task_params[:title]
    puts '+++++++++++++++++'
    if @task.save
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      redirect_to root_path, status: :see_other
    end
  end

  def toggle
    @task.update(completed: !@task.completed)
    render turbo_stream: turbo_stream.replace(
      @task,
      partial: 'completed',
      locals: { task: @task }
    )
  end

  private
  def task_params
    params.require(:task).permit(:title)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
