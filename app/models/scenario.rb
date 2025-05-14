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
  belongs_to :user
  has_many  :resources, dependent: :destroy
  has_many  :sources, dependent: :destroy

  accepts_nested_attributes_for :resources
  accepts_nested_attributes_for :sources

  validates :scenario_length, numericality: { greater_than: 0 }
  validates :scenario_length, presence: true

end
