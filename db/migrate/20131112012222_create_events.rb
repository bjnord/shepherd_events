class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :origin_ident, default: 0, null: false
      t.string :name, default: "", null: false
      t.text :leader_notes
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :recurrence_description
      t.string :group
      t.string :organizer
      t.datetime :setup_starts_at
      t.datetime :setup_ends_at
      t.text :setup_notes

      t.timestamps
    end
    add_index :events, :origin_ident
    add_index :events, :starts_at
  end
end
