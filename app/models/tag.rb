class Tag < ActiveRecord::Base
  
  acts_as_indexed  :fields => [:name]
  
  has_many :taggings
  has_many :bookmarks, :through => :taggings

  validates_uniqueness_of :name
  validates_presence_of :name
  
end
