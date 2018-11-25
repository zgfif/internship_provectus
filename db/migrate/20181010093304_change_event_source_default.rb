class ChangeEventSourceDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :events, :creation_source, 'local'
  end
end
