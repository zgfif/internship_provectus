class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: :uuid do |t|
      t.string :title
      t.string :description
      t.string :location
      t.integer :priority
      t.datetime :start_date
      t.datetime :end_date
    end
  end
end
