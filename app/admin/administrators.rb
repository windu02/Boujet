ActiveAdmin.register Administrator do
  index do
    column :id
    column :email
    column :firstname
    column :lastname
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end
  
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :firstname
      f.input :lastname
    end
    f.buttons
  end
end
