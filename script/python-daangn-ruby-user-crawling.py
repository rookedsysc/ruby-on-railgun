import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor
import time

GITHUB_URL = "https://github.com"
SEARCH_OPTIONS = "?tab=repositories&q=&type=&language=ruby&sort="

def is_this_user_use_ruby(name, href):
    url = f"{GITHUB_URL}{href}{SEARCH_OPTIONS}"
    response = requests.get(url)
    html = response.text

    soup = BeautifulSoup(html, "html.parser")
    repos = soup.select("div.col-10.col-lg-9.d-inline-block")

    return bool(repos)

def puts_if_ruby_user(users):
    def check_user(name_href):
        name, href = name_href
        if is_this_user_use_ruby(name, href):
            return f"{name} uses Ruby!!!\n{GITHUB_URL}{href}{SEARCH_OPTIONS}"
        return None

    with ThreadPoolExecutor() as executor:
        futures = [executor.submit(check_user, user) for user in users.items()]
        for future in futures:
            result = future.result()
            if result:
                print(result)

def get_user_info():
    page = 1
    users = {}
    while True:
        url = f"{GITHUB_URL}/orgs/daangn/people?page={page}"
        response = requests.get(url)
        html = response.text

        soup = BeautifulSoup(html, "html.parser")
        members = soup.select("a.f4.d-block")

        if not members:
            break

        for member in members:
            users[member.text.strip()] = member["href"]
        
        page += 1
    
    return users

def main():
    start = time.time()
    users = get_user_info()
    puts_if_ruby_user(users)
    end = time.time()

    diff_ms = (end - start) * 1000
    print(f"\nTime taken to run: {diff_ms:.2f} ms")

if __name__ == "__main__":
    main()