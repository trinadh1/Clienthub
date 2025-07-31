class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = @client.projects
  end

  def show
  end

  def new
    @project = @client.projects.new
  end

  def create
    @project = @client.projects.new(project_params)
    if @project.save
      redirect_to client_project_path(@client, @project), notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to client_project_path(@client, @project), notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to client_projects_path(@client), notice: "Project deleted successfully."
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_project
    @project = @client.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end