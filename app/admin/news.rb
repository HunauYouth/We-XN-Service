ActiveAdmin.register News do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  scope :general, group: :category
  scope :support_notice, group: :category
  scope :xshd, group: :category

  filter :title
  filter :summary
  filter :content
  filter :addtime
  filter :category, as: :select

  index do
    selectable_column
    column :title
    column :summary
    column :addtime
    actions
  end
end
