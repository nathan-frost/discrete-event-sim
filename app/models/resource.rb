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
  belongs_to :scenario

  validates :resource_time_variance, numericality: { greater_than_or_equal_to: 0 }
  validates :resource_time_mean, numericality: { greater_than_or_equal_to: 0 }
  validates :resource_time_mean, presence: true
  validates :resource_time_distribution, presence: true
  validates :resource_capacity, numericality: { greater_than: 0 }
  validates :resource_capacity, presence: true


end
