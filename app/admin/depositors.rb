ActiveAdmin.register Depositor do
  index do
    column :id
    column :email
    column :firstname
    column :lastname
    column :phone
    column :negotiation
    column :address
    column :items
    column :encrypted_password
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :created_at
    default_actions
  end
  
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :firstname
      f.input :lastname
      f.input :phone
      f.input :negotiation
    end
    f.buttons
  end
end