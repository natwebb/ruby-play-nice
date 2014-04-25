class CalCalc
  def self.zeller(q, m, y)
    q = q.to_i #q is the day of the month, e.g. the seventeenth (17)
    m = m.to_i #m is the month, e.g. April (4)
    y = y.to_i #y is the year, e.g. 1984

    #if the month is January or February, it is represented as the 13th or 14th month
    #of the previous year, respectively, so 12 is added to m and 1 subtracted from y
    if m < 3
      m += 12
      y -= 1
    end

    #h is the day of the week, starting with Saturday = 0
    h = (q + (((m+1)*26)/10) + y + (y/4) + 6*(y/100) + (y/400))
    h = h%7

    h
  end

  def self.leap?(y)
    if y%4 != 0
      false
    elsif y%100 != 0
      true
    elsif y%400 == 0
      true
    else
      false
    end
  end
end
