class ReportsController < ApplicationController
  def index
    @columns = AppConfig.pluck(:name)
    @duplicates = Report.check_duplicates
  end
end
