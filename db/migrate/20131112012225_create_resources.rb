class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :event_id, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :resources, :event_id
  end
end
