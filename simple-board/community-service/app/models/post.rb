class Post < ApplicationRecord
  # hash_many: post가 여러 개의 comments를 가짐
  # dependent: post가 삭제되면 관련된 comments도 삭제됨
  has_many :comments, dependent: :destroy
end
