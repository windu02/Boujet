ActiveAdmin.register Item do
  index do
    column :id
    column :name
    column :brand
    column :color
    column :type
    column :price
    column :other
    column :user
    column :sell
    column :created_at
    default_actions
  end
  
  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :brand
      f.input :color
      f.input :type
      f.input :price
      f.input :other
      f.input :user
      f.input :sell
    end
    f.buttons
  end
end