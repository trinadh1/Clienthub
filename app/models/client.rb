class Client < ApplicationRecord
  belongs_to :user
  has_many :projects, dependent: :destroy
  validates :name, :email, presence: true
end
