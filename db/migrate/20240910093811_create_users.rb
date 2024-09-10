class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name
      t.string :mobile_number
      t.string :email
      t.string :status
      t.string :type
      t.string :full_name
      t.timestamps
    end

    create_table :login_tokens, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :token
      t.bigint :user_id
      t.timestamps
    end
  end
end
