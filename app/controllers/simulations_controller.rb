require 'open3'
require 'json'

class SimulationsController < ApplicationController
  def create
    simulation_input = params.require(:simulation).permit!.to_h
    RunSimulationJob.perform_later(simulation_input)

    render json: { status: "enqueued", message: "Simulation started." }
  end
end
