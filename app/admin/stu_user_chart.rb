ActiveAdmin.register_page "StuUserChart" do
  menu parent: "StuUser"
  content do
    para line_chart StuUser.group_by_day(:created_at).count
  end
end
