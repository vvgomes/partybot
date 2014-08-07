require 'mechanize'
@agent = Mechanize.new

# Request URL:http://www.beco203.com.br/resources/files/nomeLista.php?id=2126
# Request Method:POST
# Form Data:
# nome:Vini Gomes
# email:vinicius.vieira.gomes@gmail.com
# idAgenda:2126
# grava:ENVIAR
def beco_parties 
  @agent.get('http://www.beco203.com.br').links_with(:href => /^agenda\//).map(&:click).map do |page|
    page.search('a[title="NOME NA LISTA"]').map{|a|a['href'].match(/id=(?<id>\d+)/)['id']}.first
  end.compact
end

# Request URL:http://cucko.com.br/nome_lista/gravaNomeLista
# Request Method:POST
# Form Data:
# nome[]:Vinicius Gomes
# email:vinicius.vieira.gomes@gmail.com
# idEvento:41
def cucko_parties
  @agent.get('http://cucko.com.br/nome_lista/nomeLista/').search('select#evento option').map{|o|o['value']}
end

# Request URL:http://www.labpoa.com.br/Gold_02/add-guest
# Request Method:POST
# Form Data:
# guests[0][email]:vinicius.vieira.gomes@gmail.com
# guests[0][name]:Vinicius Gomes
def lab_parties
  @agent.get('http://www.labpoa.com.br/agenda').search('#content ul.nav.nav-tabs.nav-stacked li a').map{|a|a['href'].delete('/')}
end

pp beco_parties
pp cucko_parties
pp lab_parties

class Party 
  include Mongoid::Document
  include Mongoid::Timestamps
  field :external_id, :type => String
end

class Nightclub
  def sync
    from_db = Party.all
    from_web = fetch_parties
    (from_db - from_web).map(&:destroy)
    (from_web - from_db).map(&:save)
  end
end

