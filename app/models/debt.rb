class Debt < ActiveRecord::Base
  belongs_to :creditor, :class_name => "User", :foreign_key => "user_from_id"
  belongs_to :debitor, :class_name => "User", :foreign_key => "user_to_id"

  validates_presence_of :user_from_id
  validates_presence_of :user_to_id
  validates_presence_of :description
  validates_presence_of :value
  validates_numericality_of :value
  
  belongs_to :user_from, :class_name => "User"
  belongs_to :user_to, :class_name => "User"
end
