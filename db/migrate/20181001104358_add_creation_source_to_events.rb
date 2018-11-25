class AddCreationSourceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :creation_source, :integer
  end
end
