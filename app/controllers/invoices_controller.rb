class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client
  before_action :set_project
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :send_email]

  def index
    @invoices = @project.invoices
  end

  def show
  @client = Client.find(params[:client_id])
  @project = @client.projects.find(params[:project_id])
  @invoice = @project.invoices.find(params[:id])
end

  def new
    @invoice = @project.invoices.new
  end

  def create
    @invoice = @project.invoices.new(invoice_params)
    if @invoice.save
      redirect_to client_project_invoice_path(@client, @project, @invoice), notice: "Invoice created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @invoice.update(invoice_params)
      redirect_to client_project_invoice_path(@client, @project, @invoice), notice: "Invoice updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to client_project_invoices_path(@client, @project), notice: "Invoice deleted."
  end
   def send_email
    @invoice = Invoice.find(params[:id])
    InvoiceEmailJob.perform_later(@invoice.id)
    redirect_to client_project_invoice_path(@invoice.project.client, @invoice.project, @invoice), notice: "Invoice is being emailed."
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def set_project
    @project = @client.projects.find(params[:project_id])
  end

  def set_invoice
    @invoice = @project.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:total_amount, :due_date, :status)
  end
end