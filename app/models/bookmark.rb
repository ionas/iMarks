class Bookmark < ActiveRecord::Base
  # Thanks go to: http://railscasts.com/episodes/167-more-on-virtual-attributes
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings #, :order => :name

  attr_writer :tag_names

  #after_save :assign_tags
  #after_update :assign_tags
  
  # Validations
  validates_presence_of :url
  validates_uniqueness_of :url
  
  # gem will_paginate
  # Thanks to:
  # => http://wiki.github.com/mislav/will_paginate/
  # => http://github.com/mislav/will_paginate/wiki
  # => http://gitrdoc.com/mislav/will_paginate/tree/master
  # => http://thewebfellas.com/blog/2010/8/22/revisited-roll-your-own-pagination-links-with-will_paginate-and-rails-3
  # => http://wiki.github.com/mislav/will_paginate/simple-search
  # => http://railscasts.com/episodes/51-will-paginate
  # => http://paulsturgess.co.uk/articles/show/89-a-ruby-on-rails-will_paginate-gotcha
  # => http://railscasts.com/episodes/176-searchlogic
  # => http://railscasts.com/episodes/111-advanced-search-form
  # => http://railscasts.com/episodes/37-simple-search-form
  # => http://wiki.github.com/mislav/will_paginate/ajax-pagination
  cattr_reader :per_page, :per_page_min, :per_page_max
  @@per_page = 5
  @@per_page_min = 3
  @@per_page_max = 100
   
  def tag_names
    @tag_names || tags.collect(&:name).join(', ')
  end
  
  def tag_names=(tag_names = nil)
    if tag_names
      self.tags = tag_names.split(/,+/).collect do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end

  
  def self.search(search, page, order_by, order_direction, per_page)
    # Treat spaces and commas and semicolons as wildcards
    search = search.gsub(' ', '%').gsub(',', '%').gsub(';', '%') unless search == nil
    # Better: LIKE %PART1% OR %PART2%, Better yet: weighted?!
    # SearchLogic: http://railscasts.com/episodes/176-searchlogic (not yet rails3)
    # Thinking Sphinx: http://railscasts.com/episodes/120-thinking-sphinx (requires rake indexing)
    # Xapian (like Lucene): http://blog.evanweaver.com/articles/2008/05/26/xapian-search-plugin/
    # http://locomotivation.squeejee.com/post/109284085/mulling-over-our-ruby-on-rails-full-text-search-options
    paginate :per_page => per_page, :page => page,
             # :conditions => ['url LIKE?', "%#{search}%"],
             :conditions => ['Bookmarks.url LIKE ? OR Tags.name LIKE ?', "%#{search}%", "%#{search}%"],
             :order => 'Bookmarks.' + order_by + ' ' + order_direction,
             :include => :tags
  end
  
  private

#  def assign_tags
#    if @tag_names
#      self.tags = @tag_names.split(/,+/).collect do |name|
#        Tag.find_or_create_by_name(name.strip)
#      end
#    end
#  end
  
end
