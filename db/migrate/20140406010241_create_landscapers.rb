class CreateLandscapers < ActiveRecord::Migration
  def change
    create_table :landscapers do |t|
      t.string :first_name
      t.string :middle_initial
      t.string :last_name
      t.string :primary_phone
      t.string :secondary_phone
      t.string :email
      t.integer :rating, default: 0
      t.string :description
      t.integer :status_code, default: 1011

      t.timestamps
    end
  end
end
