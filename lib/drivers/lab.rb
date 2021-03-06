require 'mechanize'

class Lab
  BASE_URL = 'http://www.labpoa.com.br'

  def initialize
    @agent = Mechanize.new
  end

  def import_parties
    @agent.get("#{BASE_URL}/agenda").
    search('#content ul.nav.nav-tabs.nav-stacked li a').map do |a|
      Party.new(:public_id => a['href'].delete('/'))
    end
  end

  def subscribe(guest, party)
    data = {
      'guests[0][email]' => guest.email, 
      'guests[0][name]' => guest.name
    }
    uri = "#{BASE_URL}/#{party.public_id}/add-guest"
    @agent.post(uri, data).code
  end
end
