class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
