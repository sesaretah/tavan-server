class TimeSheetSerializer < ActiveModel::Serializer
  attributes :id, :morning_report,  :afternoon_report,  :extra_report, :the_associations, :date, :jdate
  #belongs_to :user,  serializer: UserSerializer

  def date
    object.sheet_date.in_time_zone("Tehran") if object.sheet_date
  end

  def jdate
    if object.sheet_date
      sheet_date = JalaliDate.to_jalali(object.sheet_date.in_time_zone("Tehran"))
      "#{sheet_date.year}/#{sheet_date.month}/#{sheet_date.day}" 
    end
  end

  def the_associations
    object.associations
  end
end
