class ScenariosController < ApplicationController
  before_action :set_scenario, only: %i[ show edit update destroy ]

  # GET /scenarios or /scenarios.json
  def index
    @scenarios = Scenario.all
  end

  # GET /scenarios/1 or /scenarios/1.json
  def show
    @scenario = Scenario.find(params[:id])
    @outputs = @scenario.outputs.order(:entity_id, :start_service)
    @chart_data = @scenario.outputs.group(:entity_id).average(:wait_time)

    sorted = @chart_data.sort_by { |_, v| v }
    @chart_labels = sorted.map(&:first)
    @chart_values = sorted.map(&:last)
    
  end

  def refresh_outputs
    @scenario = Scenario.find(params[:id])
    @outputs = @scenario.outputs

    if @outputs.any?
      chart_data = @outputs.group(:entity_id).average(:wait_time).sort_by(&:first)
      @chart_labels = chart_data.map { |id, _| "Entity #{id}" }
      @chart_values = chart_data.map(&:last)

      render turbo_stream: turbo_stream.replace(
        "scenario_outputs_#{@scenario.id}",
        partial: "scenario_outputs",
        locals: {
          scenario: @scenario,
          outputs: @outputs,
          chart_labels: @chart_labels,
          chart_values: @chart_values
        }
      )
    else
      head :no_content
    end
  end





  # GET /scenarios/new
  def new
    @scenario = Scenario.new
    @current_user = current_user
    @scenario.resources.build
    @scenario.sources.build

  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios or /scenarios.json
  def create
    @scenario = Scenario.new(scenario_params)

    respond_to do |format|
      if @scenario.save
        json_data = @scenario.as_json(
          only: [:id, :scenario_name, :scenario_length],
          include: {
            sources: {
              only: [:arrival_interval_mean, :arrival_interval_variance, :arrival_interval_distribution]
            },
            resources: {
              only: [:resource_name, :resource_capacity, :resource_time_mean, :resource_time_variance, :resource_time_distribution, :resource_order]
            }
          }
        )

        Rails.logger.info "📦 Enqueuing RunSimulationJob for scenario #{@scenario.id}"
        RunSimulationJob.perform_later(json_data)

        format.html do
          redirect_to @scenario, notice: "Scenario was successfully created and simulation started."
        end
        format.json { render json: json_data, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @scenario.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /scenarios/1 or /scenarios/1.json
  def update
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: "Scenario was successfully updated." }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1 or /scenarios/1.json
  def destroy
    @scenario.destroy!

    respond_to do |format|
      format.html { redirect_to scenarios_path, status: :see_other, notice: "Scenario was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def scenario_params
      params.expect(scenario: [ :user_id, :scenario_name, :scenario_description, :scenario_length ])
      params.require(:scenario).permit(:scenario_name, :scenario_description, :scenario_length, :user_id,
        resources_attributes: [:id, :resource_name, :resource_description, :resource_capacity, :resource_time_mean, :resource_time_variance, :resource_time_distribution,
            :resource_order ],
        sources_attributes: [:id, :arrival_interval_mean, :arrival_interval_variance, :arrival_interval_distribution ]
  )    end
end
