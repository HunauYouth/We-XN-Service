namespace :company do
  desc 'GET Company'
  task get_company: :environment do
    include Api::ApiHelper
    url_str = Settings.hunauapi.service_host + Settings.hunauapi.service_endpoint + Settings.hunauapi.get_company
    params = {
      ak: ENV['HUNAU_API_PARAMS_AK'],
      id: ENV['HUNAU_API_PARAMS_USER_FLAG'],
      pageindex: 0,
      pagesize: 100,
      pid: '',
      skey: ''
    }
    result = request_helper(params, url_str).transform_keys!(&:downcase)

    if result["status"].to_i == 1
      companies = result["getcom"]
      companies.each do |company|
        company.transform_keys! { |k| k.gsub('Company_', '').downcase }
        Company.find_or_create_by!(company)
        puts 'Saved Company'

        params[:pid] = company["code"]
        department_result = request_helper(params, url_str).transform_keys!(&:downcase)
        if department_result["status"].to_i == 1
          departments = department_result["getdep"]
          departments.each do |department|
            department.transform_keys!(&:downcase)
            Department.find_or_create_by!(department)
            puts 'Saved Department'
          end
        end

      end
    end
  end
end
