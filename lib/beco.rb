require 'mechanize'

class Beco
  BASE_URL = 'http://www.beco203.com.br'

  def initialize
    @agent = Mechanize.new
  end

  def import_parties
    @agent.get(BASE_URL).
    links_with(:href => /^agenda\//).map(&:click).map do |page|
      page.search('a[title="NOME NA LISTA"]').map do |a|
        a['href'].match(/id=(?<id>\d+)/)['id']
      end.first
    end.compact.map{ |id| Party.new(:public_id => id) }
  end

  def send_subscription(user, party)
    data = {
      'nome' => user.name, 
      'email' => user.email,
      'idAgenda' => party.public_id,
      'grava' => 'ENVIAR'
    }
    path = '/resources/files/nomeLista.php?id=' 
    uri = [BASE_URL, path, party.public_id].join
    @agent.post(uri, data).code
  end
end
