require 'nokogiri'

class DuckTrainer
  def initialize
    @unlocks = {
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

    @indent = ' - '
  end

  def get_file
    File.open 'test_saves/76561198015076176.pro', 'r+'
  end

  def do_it
    f = get_file

    text = f.read
    xml = Nokogiri::XML text

    puts 'Profile:'
    name = xml.css('Profile LastKnownName').first.text
    puts "#{@indent}Name: #{name}"
    mood = xml.css('Profile Mood').first.text
    puts "#{@indent}Mood: #{mood}"
    tickets = xml.css('Tickets').first.text
    puts "#{@indent}Tickets: #{tickets}"

    puts 'Stats:'
    xml.css('Profile > Stats *').each do |node|
      name = tidy_stat_name node.name.to_s
      next if ['_node Name'].member? name

      puts "#{@indent}#{name}: #{node.text}"
    end

    puts 'Unlocks:'
    player_unlocks = xml.css('Profile Unlocks').first.text
    player_unlocks = player_unlocks.split '|'
    player_unlocks = player_unlocks.select { |x| x.length > 0 }
    player_unlocks = player_unlocks.map { |x| x.to_sym }

    player_unlocks.each do |unlock_name|
      puts "#{@indent}#{@unlocks[unlock_name]}"
    end
  end

  def tidy_stat_name name
    name.gsub!(/([A-Z])/, ' \1')
    name[0] = name[0].upcase

    return name
  end
end

DuckTrainer.new.do_it