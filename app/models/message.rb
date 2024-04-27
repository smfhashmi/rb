class Message < ApplicationRecord
  validate :title presence: true
  validate :description presence: true
end
