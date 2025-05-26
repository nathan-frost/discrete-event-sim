# == Schema Information
#
# Table name: outputs
#
#  id            :bigint           not null, primary key
#  arrival_time  :float
#  end_time      :float
#  resource      :string
#  service_time  :float
#  start_service :float
#  wait_time     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  entity_id     :integer
#  scenario_id   :integer
#
class Output < ApplicationRecord
  belongs_to :scenario
end
