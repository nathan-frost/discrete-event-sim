require 'aws-sigv4'
require 'httparty'

class RunSimulationJob < ApplicationJob
  queue_as :default

  def perform(scenario_data)
    url = ENV['LAMBDA_SIMULATION_URL']
    unless url
      Rails.logger.error "❌ ENV['LAMBDA_SIMULATION_URL'] is not set"
      return
    end

    payload = scenario_data.to_json

    Rails.logger.info "🚀 RunSimulationJob started for scenario #{scenario_data['id']}"
    Rails.logger.info "📤 Sending signed request to #{url}"

    signer = Aws::Sigv4::Signer.new(
      service: 'execute-api',
      region: ENV['AWS_REGION'] || 'us-east-1',
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )

    signature = signer.sign_request(
      http_method: 'POST',
      url: url,
      body: payload,
      headers: { 'Content-Type' => 'application/json' }
    )

    response = HTTParty.post(
      url,
      headers: signature.headers,
      body: payload
    )

    if response.success?
      result = JSON.parse(response.body)
      Rails.logger.info "Simulation completed: #{result.size} rows"
      
      result.each do |row|
        @scenario = Scenario.find(scenario_data["id"])
        @scenario.outputs.create!(
          entity_id: row["entity_id"],
          resource: row["resource"],
          arrival_time: row["arrival_time"],
          start_service: row["start_service"],
          end_time: row["end_time"],
          wait_time: row["wait_time"],
          service_time: row["service_time"]
        )
      end
    else
      Rails.logger.error "Lambda call failed: #{response.code} - #{response.body}"
    end
  rescue => e
    Rails.logger.error "Simulation job error: #{e.class} - #{e.message}"
    raise e
  end
end
