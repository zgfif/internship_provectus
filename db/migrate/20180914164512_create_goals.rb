class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals, id: :uuid do |t|
      t.string :title
      t.string :picture
      t.datetime :start_date
      t.datetime :end_date
      t.integer :goal_type
      t.text :s
      t.text :m
      t.text :a
      t.text :r
      t.text :t
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
