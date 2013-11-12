class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.belongs_to :event, index: true
      t.string :name, default: "", null: false

      t.timestamps
    end
  end
end
