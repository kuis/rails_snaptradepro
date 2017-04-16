class ReportsController < ApplicationController
  include ReportHelper
  skip_after_action :verify_authorized

  def index
  end

  def inventory_commitments
    @appraisals = @organization.appraisals.visible

    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@appraisals) }
      format.xls
    end
  end

  def to_csv(appraisals)
    CSV.generate do |csv|
      csv << ["TA-Number", "Stock Number", "Booked Value", "Recon Costs", "Retail Price", "Year", "Make", "Model", "Color", "VIN", "Location", "Customer"]
      appraisals.each do |appraisal|
        arr = []
        arr << appraisal.number
        arr << get_appraisal_value_by_name(appraisal, 'stock_number')
        arr << get_appraisal_value_by_name(appraisal, 'value_booked')
        arr << get_appraisal_value_by_name(appraisal, 'recon_costs')
        arr << get_appraisal_value_by_name(appraisal, 'retail_price')
        arr << get_appraisal_value_by_name(appraisal, 'year')
        arr << get_appraisal_value_by_name(appraisal, 'make')
        arr << get_appraisal_value_by_name(appraisal, 'model')
        arr << get_appraisal_value_by_name(appraisal, 'paint_color')
        arr << get_appraisal_value_by_name(appraisal, 'serial_no')
        arr << get_appraisal_value_by_name(appraisal, 'location')
        arr << appraisal.customer.account_name

        csv << arr
      end
    end
  end
end