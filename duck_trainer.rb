require 'nokogiri'
require 'win32/dir'

class DuckTrainer
  def initialize filename
    filename ||= select_profile
    @unlocks = get_unlocks
    @indent = ' - '
    @filename = filename
  end

  def get_file
    File.open @filename, 'r+'
  end

  def do_it
    f = get_file

    text = f.read
    xml = Nokogiri::XML text

    puts 'Profile:'
    name = (xml.at_css('LastKnownName') || xml.at_css('Name')).text
    puts "#{@indent}Name: #{name}"
    mood = xml.at_css('Mood').text
    puts "#{@indent}Mood: #{mood}"
    tickets = xml.at_css('Tickets').text
    puts "#{@indent}Tickets: #{tickets}"

    puts 'Stats:'
    xml.css('Stats > *').each do |node|
      name = tidy_stat_name node.name.to_s
      next if ['_node Name', '_times Killed By'].member? name

      puts "#{@indent}#{name}: #{node.text}"
    end

    puts 'Unlocks:'
    player_unlocks = tidy_unlock_list xml.at_css('Unlocks').text

    player_unlocks.each do |unlock_name|
      puts "#{@indent}#{@unlocks[unlock_name]}"
    end
  end

  def select_profile
    puts "Please Select a Profile:"
    profiles = Dir.glob File.join(get_profile_path, '*.pro')

    profile_list = {}

    profiles.each.with_index 1 do |profile, i|
      profile_list[i] = profile
    end

    profile_list.each do |i, profile|
      puts "#{@indent}#{i}: #{get_profile_name profile}"
    end

    selected = gets.to_i

    return profile_list[selected] if selected

    puts "Incorrect choice, should be a number shown!"
    exit
  end

  def get_unlocks
    {
      BASEMENTKEY: 'Basement Arcade Key',
      MOOGRAV: "Moon Gravity",
      HELMY: "Start With Helmet",
      EXPLODEYCRATES: "Exploding Props",
      INFAMMO: "Infinite Ammo",
      GUNEXPL: "Guns Explode",
      HATTY2: "Hat Pack #2",
      HATTY1: "Hat Pack #1",
      WINPRES: "Presents for Winner",
      SHOESTAR: "Start With Shoes",
      QWOPPY: "QWOP Mode",
      JETTY: "Start with Jetpack",
      CORPSEBLOW: "Exploding Corpses",
      ULTIMATE: "Ultimate (WTF?)",
    }
  end

  def tidy_stat_name name
    name.gsub!(/([A-Z])/, ' \1')
    name[0] = name[0].upcase

    return name
  end

  def tidy_unlock_list player_unlocks
    player_unlocks = player_unlocks.split '|'
    player_unlocks = player_unlocks.select { |x| x.length > 0 }
    player_unlocks = player_unlocks.map { |x| x.to_sym }
  end

  def get_profile_path
    "#{Dir::PERSONAL}/DuckGame/Profiles"
  end

  def get_profile_name profile
    File.basename profile, '.pro'
  end
end

DuckTrainer.new(ARGV[0]).do_it
