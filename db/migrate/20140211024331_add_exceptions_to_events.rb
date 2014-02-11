class AddExceptionsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :exceptions, :string
  end
end
