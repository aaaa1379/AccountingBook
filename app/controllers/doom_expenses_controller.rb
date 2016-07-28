class DoomExpensesController < ApplicationController
  before_action :set_doom_expense, only: [:show, :edit, :update, :destroy]

  # GET /doom_expenses
  # GET /doom_expenses.json
  def index
    @doom_expenses = DoomExpense.all.order(:created_at => :desc)
    doom = DoomExpense.where(:delete_at => nil).order(:created_at => :desc).first
    @total = doom.total if doom
  end

  # GET /doom_expenses/1
  # GET /doom_expenses/1.json
  def show
  end

  # GET /doom_expenses/new
  def new
    @doom_expense = DoomExpense.new(:income => 0, :expense => 0)
  end

  # GET /doom_expenses/1/edit
  def edit
  end

  # POST /doom_expenses
  # POST /doom_expenses.json
  def create
    @doom_expense = DoomExpense.new(doom_expense_params)
    diff = @doom_expense.income - @doom_expense.expense
    @doom_expense.total = counting_total(DateTime.now, diff)

    respond_to do |format|
      if @doom_expense.delete_at == nil and @doom_expense.save
        format.html { redirect_to doom_expenses_url, notice: '新增成功 Create Success' }
        format.json { render :show, status: :created, location: @doom_expense }
      else
        format.html { render :new }
        format.json { render json: @doom_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doom_expenses/1
  # PATCH/PUT /doom_expenses/1.json
  def update
    result = false
    DoomExpense.transaction do
      if not @doom_expense.delete_at and @doom_expense.update(doom_expense_params)
        # counting
        # created_at = @doom_expense.created_at
        # @doom_expenses = DoomExpense.where(:delete_at => nil).where('created_at >= ?', created_at)
        # @doom_expenses.each do |dm|
        #   diff     = dm.income - dm.expense
        #   dm.total = counting_total(dm.created_at, diff)
        #   dm.save!
        # end
        result = true
      end
    end

    respond_to do |format|
      if result
        format.html { redirect_to doom_expenses_url, notice: '更新成功 Update Success' }
        format.json { render :show, status: :ok, location: @doom_expense }
      else
        format.html { render :edit }
        format.json { render json: @doom_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doom_expenses/1
  # DELETE /doom_expenses/1.json
  def destroy
    DoomExpense.transaction do
      if @doom_expense.update(:delete_at => DateTime.now)
        created_at = @doom_expense.created_at
        @doom_expenses = DoomExpense.where(:delete_at => nil).where('created_at >= ?', created_at)
        @doom_expenses.each do |dm|
          diff     = dm.income - dm.expense
          dm.total = counting_total(dm.created_at, diff)
          dm.save!
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to doom_expenses_url, notice: '刪除成功 Delete Success' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doom_expense
      @doom_expense = DoomExpense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doom_expense_params
      params.require(:doom_expense).permit(:item, :income, :expense, :note)
    end

    def counting_total(created_at = DateTime.now, diff)
      income = DoomExpense.where(:delete_at => nil).where('created_at < ?', created_at).sum(:income)
      expend = DoomExpense.where(:delete_at => nil).where('created_at < ?', created_at).sum(:expense)
      income - expend + diff
      # diff: @doom_expense.income - @doom_expense.expense
    end

end
