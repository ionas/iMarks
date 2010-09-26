class Tagging < ActiveRecord::Base
  # HABTM Proxy
  belongs_to :tag
  belongs_to :bookmark
end
