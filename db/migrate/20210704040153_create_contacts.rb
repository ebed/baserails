class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :type
      t.string :value
      t.references :person, null: false, foreign_key: true
      t.boolean :enabled

      t.timestamps
    end
  end
end
