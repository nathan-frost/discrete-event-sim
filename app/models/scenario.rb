# == Schema Information
#
# Table name: scenarios
#
#  id                   :bigint           not null, primary key
#  scenario_description :text
#  scenario_length      :float
#  scenario_name        :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
class Scenario < ApplicationRecord
end
