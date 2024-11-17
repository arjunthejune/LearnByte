class Deck < ApplicationRecord
  has_many :cards, dependent: :destroy
  validates :title, presence: true
  accepts_nested_attributes_for :cards,
                                reject_if: :all_blank,
                                allow_destroy: true
end
