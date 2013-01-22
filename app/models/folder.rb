class Folder < ActiveRecord::Base
  validates :path, presence: true
end
