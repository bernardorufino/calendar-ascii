#!/usr/bin/env ruby
require "date"

class Date
  def wdayname
     DAYNAMES[wday]
  end
  def mname
    MONTHNAMES[month]
  end
end

class Array
  def outer_join(sep="")
    "#{sep}#{join(sep)}#{sep}"
  end
  def right_join(sep="")
    "#{join(sep)}#{sep}"
  end
  def left_join(sep="")
    "#{sep}#{join(sep)}"
  end
end

def draw_calendar(start_date, end_date, options={})
  options = {
    width: 4,
    hsep: "-",
    vsep: "|",
    msep: "+" 
  }.merge(options)

  start_date = start_date - start_date.wday
  end_date = end_date + (6 - end_date.wday)
  date = start_date

  w = options[:width]
  hsep = options[:hsep]
  vsep = options[:vsep]
  msep = options[:msep]
  wleft = 3 * w + 2
  wright = 2 * w + 1

  header = Date::DAYNAMES.map do |d| 
    s = d[0, w - 2]
    " #{s} "
  end.join(vsep)
  header = [" " * wleft, header, " " * wright].outer_join(vsep)

  line_sep_btw_months = ([hsep * w] * 7).outer_join(msep)
  line_sep_btw_months = vsep + (hsep * wleft) + line_sep_btw_months + (hsep * wright) + vsep

  line_sep_in_month = ([hsep * w] * 7).outer_join(msep)
  line_sep_in_month = vsep + (" " * wleft) + line_sep_in_month + (hsep * wright) + vsep 

  string = [line_sep_btw_months, header].right_join("\n")
  i = 1

  while date < end_date
    days = Array.new(7) do |i| 
      d = date + i
      d.day.to_s.center(w, (d == Date.today) ? "-" : " ") 
    end
    if (date + 6).month != (date - 1).month
      month = (date + 7).mname[0, wleft - 2].ljust(wleft - 2)
      month = " #{month} "
      current_line_sep = line_sep_btw_months
    elsif date.month != (date - 8).month
      month = "#{date.month} / #{date.year}".ljust(wleft - 2)
      month = " #{month} "
      current_line_sep = line_sep_in_month
    else
      month = " " * wleft
      current_line_sep = line_sep_in_month
    end
    days = [month, days, i.to_s.rjust(wright)].flatten.outer_join(vsep)
    string << current_line_sep
    string << "\n"
    string << days
    string << "\n"
    date = date + 7
    i = i + 1
  end

  string << line_sep_btw_months
  string << "\n"

  string
end

def to_date(input, ref)
  input.strip!
  if input.empty?
    Date.today
  elsif input =~ /\+\s*(\d+)/
    ref >> $1.to_i
  else
    Date.new(*input.strip.split(/\s+/).map(&:to_i))
  end
end

puts "Maybe 2014 12 01 -> 2016 09 01 ?"
print "Data inicial (yyyy mm dd): "
start_date = to_date(gets, Date.today)
print "Data final (yyyy mm dd or +m months): "
end_date = to_date(gets, start_date)

calendar = draw_calendar(start_date, end_date)
puts calendar

print "Save file (enter to dismiss): "
file_name = gets.strip
unless file_name.empty?
  File.open(file_name, "w") do |f|
    f.write(calendar)
  end
end
