class Wedding
  require 'open-uri'

  def initialize
    wedding_uri = 'https://rawgit.com/ndelrossi/beckyandnickwedding/master/wedding.yml'

    if Rails.env.production?
      @data = YAML.parse(open(wedding_uri)).to_ruby || YAML.load_file("#{Rails.root}/wedding.yml")
    else
      @data = YAML.load_file("#{Rails.root}/wedding.yml")
    end
  end

  def city_and_state
    @data.fetch('location')['city'] + ", " + @data.fetch('location')['state']
  end

  def address_for_maps
    @data.fetch('location')['street'] + "+" + city_and_state.gsub(' ', '+')
  end

  def method_missing(m, *args, &block)
    data = @data.fetch("#{m}")

    if data.empty?
      puts "There is no field with the name: #{m}"
    else
      data
    end
  end
end
