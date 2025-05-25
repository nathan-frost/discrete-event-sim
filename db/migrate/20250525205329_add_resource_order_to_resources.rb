class AddResourceOrderToResources < ActiveRecord::Migration[8.0]
  def change
    add_column :resources, :resource_order, :integer
  end
end
