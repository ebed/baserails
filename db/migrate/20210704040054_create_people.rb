class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :name
      t.string :lastname
      t.string :identificator
      t.string :identificator_type
      t.references :user, null: false, foreign_key: true
      t.date :dob

      t.timestamps
    end
  end
end
