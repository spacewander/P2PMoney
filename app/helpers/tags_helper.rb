module TagsHelper

  # convert into chinese date format
  # Params:
  # +date+:: +Date+ Object
  def chinese_date_format(date)
    return if date.nil?
    year = date.year
    month = date.mon
    day = date.mday

    "#{year}年#{month}月#{day}日"
  end
end
