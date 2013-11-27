class RecurrenceError < StandardError
end

class Recurrence
  def initialize(description)
    description.gsub!(/\s+from\s+\d+:\d+\s+[AP]M\s+to\s+\d+:\d+\s+[AP]M/, '')
    if m = /\s+until\s+(\w+\s+\d+,\s+\d+)/.match(description)
      @until = Date.parse(m[1])
      description.gsub!(/\s+until\s+\w+\s+\d+,\s+\d+/, '')
    end
    if m = /Every\s+day/.match(description)
      @freq = 'DAILY'
    elsif m = /Every\s+week\s+on\s+(\w+)/.match(description)
      @freq = 'WEEKLY'
      @byday = m[1][0..1].upcase
    elsif m = /Every\s+month\s+on\s+the\s+(\w+)\s+(\w+)\s+of\s+the\s+month/.match(description)
      @freq = 'MONTHLY'
      @byday = deordinal(m[1]).to_s + m[2][0..1].upcase
    else
      raise RecurrenceError "unknown recurrence '#{description}'"
    end
  end

  def rrule
    rr = "FREQ=#{@freq}"
    if @until
      rr += ";UNTIL=#{@until.strftime('%Y%m%d')}T000000Z"
    end
    if @byday
      rr += ";BYDAY=#{@byday}"
    end
    rr
  end

private

  def deordinal(ord)
    case ord
    when 'last'
      n = -1
    when 'first'
      n = 1
    when 'second'
      n = 2
    when 'third'
      n = 3
    when 'fourth'
      n = 4
    when 'fifth'
      n = 5
    else
      raise RecurrenceError "unknown ordinal '#{ord}'"
    end
    n
  end
end