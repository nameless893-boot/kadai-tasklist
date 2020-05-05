class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :user_logged_in, only: [:index, :show]
   before_action :correct_user, only: [:destroy]
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Taskが投稿されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render 'tasks/index'
    end
  end
  
  def edit
  end
  
  def update

    if @task.update(task_params)
      flash[:success] = 'Taskが更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskが更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'Taskが削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
    
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
