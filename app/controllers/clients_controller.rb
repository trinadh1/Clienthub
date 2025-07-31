class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients
  end

  def show
    authorize @client
  end

  def new
    @client = current_user.clients.new
  end

  def create
    @client = current_user.clients.new(client_params)
    if @client.save
      respond_to do |format|
        format.html { redirect_to clients_path, notice: "Client created!" }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Add edit, update, destroy actions similarly
   def edit
    authorize @client
  end

  def update
  authorize @client
  if @client.update(client_params)
    redirect_to @client, notice: "Client updated."
  else
    render :edit
  end
end
  
  def destroy
  authorize @client
  @client.destroy
  redirect_to clients_path, notice: "Client deleted."
end


  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email)
  end
end