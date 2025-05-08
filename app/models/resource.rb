# == Schema Information
#
# Table name: resources
#
#  id                         :bigint           not null, primary key
#  resource_capacity          :float
#  resource_description       :text
#  resource_name              :string
#  resource_time_distribution :string
#  resource_time_mean         :float
#  resource_time_variance     :float
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  scenario_id                :integer
#
class Resource < ApplicationRecord
end
