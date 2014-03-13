module DateHelper

  def last_day_of_month(year=Date.today.year, month=Date.today.month)
    Date.civil(year, month, -1)
  end
  module_function :last_day_of_month

  def first_day_of_month(year=Date.today.year, month=Date.today.month)
    Date.civil(year, month, 1)
  end
  module_function :first_day_of_month

end