# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, presence: true
  validates :sell_in, presence: true
  validates :quality, presence: true

  default_scope { order(created_at: :desc) }
end
