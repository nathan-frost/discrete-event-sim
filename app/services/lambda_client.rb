require 'aws-sdk-lambda'

class LambdaClient
  def self.client
    @client ||= Aws::Lambda::Client.new(region: ENV['AWS_REGION'])
  end

  # Call this to test the connection
  def self.test_connection
    client.list_functions(max_items: 1) # lightweight call
    true
  rescue Aws::Lambda::Errors::ServiceError => e
    Rails.logger.error "Lambda connection failed: #{e.message}"
    false
  end
end
