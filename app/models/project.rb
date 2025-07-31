class Project < ApplicationRecord
  belongs_to :client
  has_many :invoices, dependent: :destroy

  validates :title, presence: true
end
