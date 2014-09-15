require 'mechanize'

class Beco
  BASE_URL = 'http://www.beco203.com.br'

  def initialize
    @agent = Mechanize.new
  end

  def subscribe(guest, party)
    data = {
      'nome' => guest.name, 
      'email' => guest.email,
      'idAgenda' => party.public_id,
      'grava' => 'ENVIAR'
    }
    path = '/resources/files/nomeLista.php?id=' 
    uri = [BASE_URL, path, party.public_id].join
    @agent.post(uri, data).code
  end

  def import_parties
    home = @agent.get(BASE_URL)
    rs_home = fetch_rs_home(home)
    links = find_party_links(rs_home)
    pages = links.map(&:click)
    ids = pages.map do |page|
      list_link = find_list_link(page)
      find_public_id(list_link) if list_link
    end.compact
    ids.map{ |id| Party.new(:public_id => id) }
  end

  private

  def fetch_rs_home(home)
    link = home.link_with(:href => '/estado.php?estado=RS')
    raise 'failed to fetch rs home' unless link
    link.click
  end

  def find_party_links(rs_home)
    links = rs_home.links_with(:href => /^agenda\//)
    raise 'failed to find party links' if links.empty?
    links
  end

  def find_list_link(party_page)
    party_page.search('a[title="NOME NA LISTA"]').first
  end

  def find_public_id(list_link)
    id = list_link['href'].match(/id=(?<id>\d+)/)['id']
    raise 'failed to find public id' unless id
    Integer(id).to_s # must be a number
  end
end
