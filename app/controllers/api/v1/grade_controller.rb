class Api::V1::GradeController < Api::BaseController
  include Api::V1::GradeHelper

  def index
    stuNumber = params["stuNumber"]
    stuCardCode = params["stuCardCode"]
    @stuGrades = handle_grade(stuCardCode)
    @stuGrades = StuGrade.where(xh: stuNumber).group_by(&:xn)
    render :json => {
      status: 'success',
      message: '请求成功',
      grades: @stuGrades
    }
  end
end
