class OrderItem < ApplicationRecord
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def validate_quantity
    unless self.quantity <= self.product.inventory
      self.errors.add(:quantity, "Number of #{self.product.name} added to card exceeds seller's in-stock inventory(#{self.product.inventory}). Please enter a smaller quantity.")
    else
      return self.card_brand
    end
  end
end
