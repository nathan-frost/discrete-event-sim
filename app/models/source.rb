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
  belongs_to :scenario

  validates :arrival_interval_variance, numericality: { greater_than_or_equal_to: 0 }
  validates :arrival_interval_mean, numericality: { greater_than_or_equal_to: 0 }
  validates :arrival_interval_mean, presence: true
  validates :arrival_interval_distribution, presence: true

end
