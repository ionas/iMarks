class Tagging < ActiveRecord::Base
  # HABTM Proxy
  belongs_to :tag
  belongs_to :bookmark
  # Unique pair:
  validates_uniqueness_of :tag_id, :scope => :bookmark_id
end
