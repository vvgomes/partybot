require 'mechanize'

class Cucko
  BASE_URL = 'http://cucko.com.br/nome_lista'

  def import_parties
    Mechanize.new.get("#{BASE_URL}/nomeLista").
    search('select#evento option').map do |o|
      Party.new(:public_id => o['value'])
    end
  end

  def send_subscription(user, party)
    data = {
      'nome[]' => user.name, 
      'email' => user.email,
      'idEvento' => party.public_id
    }
    Net::HTTP.post_form(URI("#{BASE_URL}/gravaNomeLista"), data).code
  end
end
