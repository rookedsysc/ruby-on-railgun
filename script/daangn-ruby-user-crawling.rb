require 'nokogiri'
require 'http'

$github_url = "https://github.com"

def is_this_user_use_ruby name, href
  url = "#{$github_url}#{href}?tab=repositories&q=&type=&language=ruby&sort="
  response = HTTP.get(url)
  html = response.body.to_s

  doc = Nokogiri::HTML(html)

  repos = doc.css('div.col-10.col-lg-9.d-inline-block')

  if not repos.empty?
    puts "#{name} is using Ruby!"
    puts "#{$github_url}#{href}"
  end
end

def get_user_info 
  page = 1
  while true do
    url = "#{$github_url}/orgs/daangn/people?page=#{page}"
    response = HTTP.get(url)
    html = response.body.to_s
  
    doc = Nokogiri::HTML(html)
  
    members = doc.css('a.f4.d-block')
    names = []
    urls = []
  
    # 이름이랑 url 출력
    members.each do |member|
      urls << member['href']
      names << member.text.strip
    end

    for i in 0..names.length 
      is_this_user_use_ruby names[i], urls[i]
    end
  
    if names.empty?
      break
    end
    page += 1
  end
end

get_user_info