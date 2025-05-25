require 'aws-sigv4'
require 'httparty'

class RunSimulationJob < ApplicationJob
  queue_as :default

  def perform(scenario_data)
    url = ENV['LAMBDA_SIMULATION_URL']
    uri = URI.parse(url)

    signer = Aws::Sigv4::Signer.new(
      service: 'execute-api',
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )

    signature = signer.sign_request(
      http_method: 'POST',
      url: url,
      body: scenario_data.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    response = HTTParty.post(
      url,
      headers: signature[:headers],
      body: signature[:body]
    )

    if response.success?
      result = JSON.parse(response.body)
      Rails.logger.info "✅ Simulation completed: #{result.size} rows"
      # Optionally save or return result here
    else
      Rails.logger.error "❌ Lambda call failed: #{response.code} - #{response.body}"
    end
  rescue => e
    Rails.logger.error "❌ Simulation job error: #{e.message}"
  end
end
