class ReportsController < ApplicationController
  def index
    @columns = AppConfig.order(name: 1).pluck(:name)
    @duplicates = Report.check_duplicates
  end
end
