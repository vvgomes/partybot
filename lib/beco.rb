require 'mechanize'

class Beco
  BASE_URL = 'http://www.beco203.com.br'

  def import_parties
    home = Mechanize.new.get(BASE_URL)
    party_links = home.links_with(:href => /^agenda\//)
    party_links.map(&:click).map do |page|
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
    Net::HTTP.post_form(post_uri(party), data).code
  end

  private

  def post_uri(party)
    path = '/resources/files/nomeLista.php?id=' 
    URI([BASE_URL, path, party.public_id].join)
  end
end
