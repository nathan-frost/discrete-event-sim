class ChangeWaitTimeTypeInOutput < ActiveRecord::Migration[8.0]
  def change
      change_column :outputs, :wait_time, :float, using: 'wait_time::double precision'

  end
end
