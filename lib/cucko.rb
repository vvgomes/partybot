require 'mechanize'

class Cucko
  BASE_URL = 'http://cucko.com.br/nome_lista'

  def initialize
    @agent = Mechanize.new
  end

  def import_parties
    @agent.get("#{BASE_URL}/nomeLista").
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
    uri = "#{BASE_URL}/gravaNomeLista"
    @agent.post(uri, data).code
  end
end
