# == Schema Information
#
# Table name: sources
#
#  id                            :bigint           not null, primary key
#  arrival_interval_distribution :string
#  arrival_interval_mean         :float
#  arrival_interval_variance     :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  scenario_id                   :integer
#
class Source < ApplicationRecord
end
