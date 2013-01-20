class Box < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  
  belongs_to :user
end
