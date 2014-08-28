require 'mechanize'

class Cucko
  BASE_URL = 'http://cucko.com.br/nome_lista'

  def initialize
    @agent = Mechanize.new
  end

  def import_parties
    @agent.get("#{BASE_URL}/nomeLista").
    search('select#evento option').map do |o|
      id = Integer(o['value']).to_s
      Party.new(:public_id => id)
    end
  end

  def subscribe(user, party)
    data = {
      'nome[]' => user.name, 
      'email' => user.email,
      'idEvento' => party.public_id
    }
    uri = "#{BASE_URL}/gravaNomeLista"
    @agent.post(uri, data).code
  end
end
