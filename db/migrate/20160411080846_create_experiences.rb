class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :spree_experiences do |t|
      t.boolean    :active, default: false, null: false
      t.references :address
      t.string     :email
      t.string     :name
      t.string     :url
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :spree_experiences, :address_id
    add_index :spree_experiences, :deleted_at
    add_index :spree_experiences, :active
  end
end
