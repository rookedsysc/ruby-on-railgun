## Ruby On Rails Doc

## How To Start

- Rails 서버는 변경을 자동으로 감지해서 Autoloading이 된다고 함

```console
rails server
```

## DB 연결

- MySQL을 연결해볼려고 했는데 무슨 zstd?가 없다면서 안됐음 
  - zstd를 설치하고 which zstd로 경로 찾아져서 path 설정해줬는데도 안됨
  - 그러다가 문득 공고에서 postgresql을 쓰고 있다는게 기억남
  - ~~설마 이것때문에..?~~postgresql로 변경

- DB 생성
  - database.yml에서 설정한대로 DB 생성해주는 명령

```console
rails db:create
```

- DB 마이그레이션
  - db/migrate 폴더에 있는 파일들을 실행시켜주는 명령

```console
rails db:migrate
```

## CLI

### Model 생성

- 👇 명령어를 치면 app/models 폴더에 post.rb 파일과 db/migrate 폴더에 `날짜_create_post.rb` 파일이 생김
  - Nest CLI랑 비슷한듯..?
  - 근데 테이블은 복수형이 아니라 단수형으로 알고 있는데 posts로 생성이 됨

```console 
rails generate model Post title:string content:text
```
