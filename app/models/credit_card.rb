class CreditCard < ActiveRecord::Base

  validates :cvv, :number, presence: true
  validates_format_of  :number, with: /\A\d{16}\z/
  validates :expiration_month,
            inclusion: { in: 1..12 },
            presence: true
  validates :expiration_year,
            presence: true,
            inclusion: { in: Time.now.year..Time.now.year + 20 }
end
