class Bookmark < ActiveRecord::Base
  # Thanks go to: http://railscasts.com/episodes/167-more-on-virtual-attributes
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings #, :order => :name

  attr_writer :tag_names

  after_save :assign_tags
  after_update :assign_tags
  
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
  cattr_reader :per_page
  @@per_page = 5 # default items per page
   
  def tag_names
    @tag_names || tags.collect(&:name).join(', ')
  end
  
  def self.search(search_by_url, search_by_tags, page, order_by, order_direction, per_page = nil)
    per_page || @@per_page
    # Treat spaces and commas and semicolons as wildcards
    search_by_url = search_by_url.gsub(' ', '%').gsub(',', '%').gsub(';', '%') unless search_by_url == nil
    # Better: LIKE %PART1% OR %PART2%, Better yet: weighted?!
    # SearchLogic?
    
    paginate :per_page => per_page, :page => page,
             :conditions => ['url LIKE ? ', "%#{search_by_url}%"],
             # :conditions => ['url LIKE ? AND tag_names LIKE ?', "%#{search_by_url}%", "%#{search_by_tags}%"],
             :order => order_by + ' ' + order_direction
  end
  
  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,+/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end
  
end
