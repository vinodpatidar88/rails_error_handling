ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  filter :email
  filter :created_at
  filter :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end
end