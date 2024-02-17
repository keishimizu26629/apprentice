def time(s)
    seconds = s % 60
    minutes = (s - seconds) / 60
    hours = minutes / 60
    minutes = minutes % 60
    puts "#{hours}:#{minutes}:#{seconds}"
  end
  
  time(4210)