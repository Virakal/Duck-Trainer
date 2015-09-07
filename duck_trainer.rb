require 'nokogiri'

class DuckTrainer
  @unlocks = %w{BASEMENTKEY MOOGRAV HELMY EXPLODEYCRATES INFAMMO GUNEXPL HATTY2 HATTY1 WINPRES SHOESTAR QWOPPY JETTY CORPSEBLOW ULTIMATE}

  def get_file
    File.open 'test_saves/76561198015076176.pro', 'r+'
  end

  def do_it
    f = get_file

    text = f.read
    xml = Nokogiri::XML text

    puts xml.inspect
  end
end

DuckTrainer.new.do_it