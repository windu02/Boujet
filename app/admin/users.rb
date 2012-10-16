ActiveAdmin.register User do
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :firstname
      f.input :lastname
      f.input :phone
      f.input :negotiation
      f.input :type
    end
    f.buttons
  end
end
