class DebtsController < ApplicationController
  before_filter :authenticate
  before_filter :requests

  # GET /debts
  # GET /debts.json
  def index
    @friends = current_user.friends_sorted
    @debt = Debt.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /debts/1
  # GET /debts/1.json
  def show
    @debt = Debt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @debt }
    end
  end

  # GET /debts/new
  # GET /debts/new.json
  def new
    @debt = Debt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @debt }
    end
  end

  # GET /debts/1/edit
  def edit
    @debt = Debt.find(params[:id])
  end

  # POST /debts
  # POST /debts.json
  def create
    @debt = Debt.new(params[:debt])

    if params[:debit]
      @debt.user_from_id, @debt.user_to_id = @debt.user_to_id, @debt.user_from_id
    end

    if @debt.save
      redirect_to :back, :notice => t(:debt_added) 
      # todo: send message to receiver if is_user?
    else
      redirect_to :back, :alert => "#{t(:debt_not_added)}. #{error_format @debt.errors}"
    end
  end

  # PUT /debts/1
  # PUT /debts/1.json
  def update
    @debt = Debt.find(params[:id])

    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        format.html { redirect_to @debt, notice: t(:debt_updated) }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debts/1
  # DELETE /debts/1.json
  def destroy
    @debt = Debt.find(params[:id])
    @debt.destroy

    respond_to do |format|
      format.html { redirect_to debts_url, notice: t(:debt_destroyed) }
      format.json { head :ok }
    end
  end

  private
    def error_format errors
      errors_string = ""
      errors.each do |key, value|
        errors_string << "<p>#{Debt.human_attribute_name(key)}: #{value}</p>"  
      end 
      errors_string
    end

    def requests
      return unless params[:reqiest_ids]
      requests = graph.get_object('me/apprequests')["data"]
      #graph.batch do |graph_api|
        requests.each { |request| graph.delete_object(request["id"]) }
      #end
    end
end
