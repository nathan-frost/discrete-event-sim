json.extract! resource, :id, :scenario_id, :resource_name, :resource_description, :resource_capacity, :resource_time_mean, :resource_time_variance, :resource_time_distribution, :created_at, :updated_at
json.url resource_url(resource, format: :json)
