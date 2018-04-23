# This file should contain all the record creation needed arrive_city seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def day_one_buses
  return { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Ipoh", "link" => "https://balik.undirabu.com/bus/jb-ipoh/"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/jb-kuala-lumpur/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Melaka", "link" => "https://balik.undirabu.com/bus/jb-melaka"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Negeri Sembilan", "link" => "https://balik.undirabu.com/bus/jb-negeri-sembilan"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Pulau Pinang", "link" => "https://balik.undirabu.com/bus/kl-pulau-pinag/"},
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Taiping", "link" => "https://balik.undirabu.com/bus/jb-taiping/"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Alor Setar", "link" => "https://balik.undirabu.com/bus/kl-alor-setar/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Bagan Serai", "link" => "https://balik.undirabu.com/bus/kl-bagan-serai/"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Ipoh", "link" => "https://balik.undirabu.com/bus/kl-ipoh/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/kl-johor-bahru/"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Kota Bahru", "link" => "https://balik.undirabu.com/bus/kl-kota-bahru/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Kuantan", "link" => "https://balik.undirabu.com/bus/kl-kuantan/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Melaka", "link" => "https://balik.undirabu.com/bus/kl-melaka/"}, 
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Pulau Pinang", "link" => "https://balik.undirabu.com/bus/jb-pulau-pinang/"},	
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Puchong", "arrive_city" => "Batu Pahat", "link" => "https://balik.undirabu.com/bus/kl-batu-pahat/"},
  { "date" => "8 May 2018", "time" => "8:00 PM", "depart_city" => "Puchong", "arrive_city" => "Muar", "link" => "https://balik.undirabu.com/bus/kl-muar/"}
end

def day_two_buses
  return { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Alor Setar", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/alor-setar-kl/"}, 
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Bagan Serai", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/bagan-serai-kl-return/"},
  { "date" => "9 May 2018", "time" => "5:30 PM", "depart_city" => "Batu Pahat", "arrive_city" => "Puchong", "link" => "https://balik.undirabu.com/bus/batu-pahat-puchong-return/"},
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Ipoh", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/ipoh-kl-return/"},	
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Ipoh", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/ipoh-jb-return/"},	
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Johor Bahru", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/johor-bahru-kl-return/"}, 
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Kota Bahru", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/kota-bahru-kl-return/"},
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Kuala Lumpur", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/kuala-lumpur-jb-return/"}, 
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Kuantan", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/kuantan-kl/"},	
  { "date" => "9 May 2018", "time" => "5:30 PM", "depart_city" => "Melaka", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/melaka-johor-bahru-9may2018/"},	
  { "date" => "9 May 2018", "time" => "5:30 PM", "depart_city" => "Melaka", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/melaka-kl-9may2018/"},	
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Muar", "arrive_city" => "Puchong", "link" => "https://balik.undirabu.com/bus/muar-puchong/"},
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Negeri Sembilan", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/negerisembilan-jb-return/"},	
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Pulau Pinang", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/pulau-pinang-jb-return/"}, 
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Pulau Pinang", "arrive_city" => "Kuala Lumpur", "link" => "https://balik.undirabu.com/bus/pulau-pinang-kl/"},
  { "date" => "9 May 2018", "time" => "6:00 PM", "depart_city" => "Taiping", "arrive_city" => "Johor Bahru", "link" => "https://balik.undirabu.com/bus/taiping-jb-return/"}
end

Bus.create(day_one_buses)
Bus.create(day_two_buses)