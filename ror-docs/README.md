## Ruby On Rails Doc

## How To Start

- project 생성 방법 (폴더 통째로 생성됨)

```console filename="" copy showLineNumbers
rails new project-name
```

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

## Swagger

- Gemfile에 Dependency 추가

```Gemfile
gem 'rswag-api'
gem 'rswag-ui'
group :development, :test do
  gem 'rspec-rails'
  gem 'rswag-specs'
end
```

- rswag 설치 및 Doc 생성

```console
bundle install
rails g rswag:api:install
rails g rswag:ui:install
rails generate rswag:specs:install
```

- RestDocs처럼 Test 코드 작성해야 하는 것 같아서 일단은 포기함(이게 우선 순위가 아닐테니)

## CLI

### CLI 진입 

```console
rails console
```

- console 진입하고 `find, all, create` 등의 명령어로 DB 조작 가능

### Model 생성

- 👇 명령어를 치면 app/models 폴더에 post.rb 파일과 db/migrate 폴더에 `날짜_create_post.rb` 파일이 생김
  - Nest CLI랑 비슷한듯..?
  - 근데 테이블은 복수형이 아니라 단수형으로 알고 있는데 posts로 생성이 됨

```console 
rails generate model Post title:string content:text
```

#### Model 연관관계 설정

- 위 Post 모델에 연관관계를 설정한다면, (모델명):references로 참조를 걸 수 있음

```console filename="" copy showLineNumbers
rails g model Comment content:text post:references
rails db:migrate
```

### Controller 생성

- 생성 명령어 (test 파일 같이 생성됨)

```console filename="" copy showLineNumbers
rails g controller api/v1/posts
```

- routes.rb에 routing 해줘야 함

```ruby filename="" showLineNumbers copy
Rails.application.routes.draw do
  namespace :api do # 폴더 
    namespace :v1 do # 폴더 
      resources :posts # 파일
    end
  end
end
```

#### 하위 경로로 Routing

- comments를 posts 하위 경로로 routing하고 싶다면 posts에다가 resources로 comments를 넣어주면 됨

```ruby filename="" copy showLineNumbers
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments
      end
    end
  end
end
```

#### Routing 분리 

- 개발하다가 create, index는 posts의 하위 경로로 하고 update, destroy는 comments부터 경로가 시작했으면 했음
- 그래서 routes.rb의 only 파라미터에 어떤 메서드가 posts 밑으로 갈지 어떤 메서드가 comments로 시작할지 정의 가능한 사실 발견

```ruby filename="" copy showLineNumbers
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: %i[index create]
      end
      resources :comments, only: %i[update destroy]
    end
  end
end
```

