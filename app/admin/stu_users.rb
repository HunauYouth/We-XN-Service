ActiveAdmin.register StuUser do

  permit_params do
    permitted = [:permitted, :attributes]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  menu parent: "StuUser"

  filter :schno
  filter :name
  filter :collegename, as: :select
  filter :majorname

  index do
    selectable_column
    column :name
    column :grade
    column :college
    column :collegename
    column :majorname
    column :classesname
    column :cardcode
    column :schno
    column :created_at
    actions
  end
end
