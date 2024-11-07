class CreateEndUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :end_users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.text :introduction

      t.timestamps
    end
  end
end
