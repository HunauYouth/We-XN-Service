class Api::V1::OfficephoneController < Api::BaseController
  def index
    @companies = Company.select(:id, :code, :name)
    render :json => {
      status: 200,
      message: 'success',
      data: @companies
    }
  end

  def show
    @company = Company.find(params[:id])
    @department = @company.departments.select(:id, :depname, :tell, :fax, :tellname, :address)
    render :json => {
      status: 200,
      message: 'success',
      data: @department
    }
  end
end
