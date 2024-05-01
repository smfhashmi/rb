class Comment < ApplicationRecord
  validates :title, presence: true
end
