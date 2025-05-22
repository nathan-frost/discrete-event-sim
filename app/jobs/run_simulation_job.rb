class RunSimulationJob < ApplicationJob
  queue_as :default

  def perform(simulation_json)
    script = Rails.root.join('lib/simulation/run_simulation.py')
    input = simulation_json.to_json

    stdout, stderr, status = Open3.capture3("python3 #{script}", stdin_data: input)

    if status.success?
      results = JSON.parse(stdout)

      scenario_id = simulation_json["id"]
      ActionCable.server.broadcast(
        "simulation_results_#{scenario_id}",
        { status: "complete", results: results }
      )

    else
      Rails.logger.error("Simulation failed: #{stderr}")
      scenario_id = simulation_json["id"]
      ActionCable.server.broadcast(
        "simulation_results_#{scenario_id}",
        { status: "error", error: stderr }
      )
    end
  end
end
