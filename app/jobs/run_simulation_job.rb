class RunSimulationJob < ApplicationJob
  queue_as :default

  def perform(simulation_json)
    script = Rails.root.join('lib/simulation/run_simulation.py')
    input = simulation_json.to_json

    stdout, stderr, status = Open3.capture3("python3 #{script}", stdin_data: input)

    if status.success?
      Rails.logger.info("🎉 Simulation complete! Output:")
      Rails.logger.info(stdout)  # <--- print simulation results to server log
    else
      Rails.logger.error("💥 Simulation failed:")
      Rails.logger.error(stderr)
    end
  end
end
