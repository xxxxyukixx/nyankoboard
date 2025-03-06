class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :nickname
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
