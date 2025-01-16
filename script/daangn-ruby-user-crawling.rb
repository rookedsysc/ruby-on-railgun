require 'nokogiri'
require 'http'

=begin
당근은 Ruby를 사용하는 회사 중 가장 유명한 회사입니다.
악의적인 목적으로 만들어진 것이 아닌,
Ruby를 공부하기에 앞서 당근팀의 코드 작성 스타일을 알기 위해서 작성된 스크립트 입니다.
=end

$github_url = "https://github.com"
$search_options = "?tab=repositories&q=&type=&language=ruby&sort="

def is_this_user_use_ruby name, href
  url = "#{$github_url}#{href}#{$search_options}"
  response = HTTP.get(url)
  html = response.body.to_s

  doc = Nokogiri::HTML(html)

  repos = doc.css('div.col-10.col-lg-9.d-inline-block')

  if not repos.empty?
    true
  else 
    false
  end
end

def puts_if_ruby_user users
  users.each do |name, href|
    if is_this_user_use_ruby name, href
      puts "#{name} uses Ruby!!!"
      puts "#{$github_url}#{href}#{$search_options}"
    end
  end
end

def get_user_info 
  page = 1
  users = {}
  while true do
    url = "#{$github_url}/orgs/daangn/people?page=#{page}"
    response = HTTP.get(url)
    html = response.body.to_s
  
    doc = Nokogiri::HTML(html)
  
    members = doc.css('a.f4.d-block')

    flag = true
  
    # 이름이랑 url 출력
    members.each do |member|
      # key(name) : value(href)
      users[member.text.strip] = member['href']
      if flag == true
        flag = false
      end
    end

    if flag == true
      break
    end
    page += 1
  end
  users
end

def main
  start = Time.now
  users = get_user_info
  puts_if_ruby_user users
  finish = Time.now

  diff_ms = (finish - start) * 1000
  puts "\nTime taken to run: #{diff_ms} ms"
end

main