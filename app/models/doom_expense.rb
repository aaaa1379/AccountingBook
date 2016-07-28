class DoomExpense < ActiveRecord::Base
  validates :item, :presence => true
end
