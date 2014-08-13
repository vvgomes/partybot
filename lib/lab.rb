require 'mechanize'

class Lab
  BASE_URL = 'http://www.labpoa.com.br'

  def import_parties
    Mechanize.new.get("#{BASE_URL}/agenda").
    search('#content ul.nav.nav-tabs.nav-stacked li a').map do |a|
      Party.new(:public_id => a['href'].delete('/'))
    end
  end

  def send_subscription(user, party)
    data = {
      'guest[0][email]' => user.email, 
      'guest[0][name]' => user.name
    }
    Net::HTTP.post_form(post_uri(party), data).code
  end

  private

  def post_uri(party)
    URI("#{BASE_URL}/#{party.public_id}/add-guest")
  end
end
