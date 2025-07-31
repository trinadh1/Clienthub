require 'active_record/enum'

class Invoice < ApplicationRecord
  belongs_to :project
 # enum status: { draft: 'draft', sent: 'sent', paid: 'paid' }
  validates :due_date, :total_amount, presence: true

  after_initialize :set_default_status, if: :new_record?
   private

  def set_default_status
    self.status ||= 'draft'
  end
end

