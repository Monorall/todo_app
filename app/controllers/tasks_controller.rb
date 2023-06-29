class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_request!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :toggle_status]
  def index
    @tasks = current_user.tasks.paginate(page: params[:page], per_page: 4)
    @total_tasks = current_user.tasks.count
    @task = Task.new
  end

  def show
  end

  def new
    @task = current_user.tasks.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.status = false

    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      @tasks = current_user.tasks
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully destroyed.'
  end


  def toggle_status
    @task = Task.find(params[:id])
    @task.update(status: !@task.status)
    redirect_to tasks_path
  end


  private
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :status)
  end
end
