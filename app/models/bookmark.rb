require "uri"

class Bookmark < ActiveRecord::Base
  # Thanks go to: http://railscasts.com/episodes/167-more-on-virtual-attributes
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  attr_writer :tag_names
  after_save :assign_tags
  after_update :assign_tags

  # Validations
  validates_presence_of :url
  validates_uniqueness_of :url

  validates_format_of :url, :with => URI.regexp

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
  @@per_page_min = 1
  @@per_page_max = 100

  def tag_names
    @tag_names || tags.collect(&:name).join(', ')
  end

  # Also see: http://locomotivation.squeejee.com/post/109284085/mulling-over-our-ruby-on-rails-full-text-search-options
  # SearchLogic: http://railscasts.com/episodes/176-searchlogic (not yet rails3)
  # Thinking Sphinx: http://railscasts.com/episodes/120-thinking-sphinx (requires rake indexing)
  # Xapian (like Lucene): http://blog.evanweaver.com/articles/2008/05/26/xapian-search-plugin/
  # http://squeejee.com/blog/2008/07/23/simple-ruby-on-rails-full-text-search-using-xapian/
  # Acts_As_Indexed: http://douglasfshearer.com/blog/rails-plugin-acts_as_indexed
  def self.search(search, page, order_by, order_direction, per_page)
    # Treat spaces and commas and semicolons as wildcards
    search = search.downcase.gsub(' ', '%') unless search == nil
    # ^ Better: LIKE %PART1% OR %PART2% / Better yet: weighted?!
    if search == '' # If its empty, we can use a simple find: LIKE "%%" not good.
      paginate :per_page => per_page, :page => page,
        :order => order_by + ' ' + order_direction,
        :include => [:taggings, :tags]
    else
      # Also: order_by and order_direction require SQL injection protection, in before
      paginate_by_sql ['
          SELECT bookmarks.id, bookmarks.url, bookmarks.updated_at, tags.name
          FROM bookmarks
          LEFT OUTER JOIN taggings ON taggings.bookmark_id = bookmarks.id
          LEFT OUTER JOIN tags ON tags.id = taggings.tag_id
          LEFT OUTER JOIN taggings AS taggings_join ON bookmarks.id = taggings_join.bookmark_id
          LEFT OUTER JOIN tags AS tags_join ON taggings_join.tag_id = tags_join.id
          WHERE (
            bookmarks.url LIKE ?
            OR (
              bookmarks.url LIKE ?
              AND bookmarks.id = taggings.bookmark_id
              AND taggings.tag_id = tags.id
              AND tags.id = tags_join.id
            )
          ) OR (
            tags_join.name LIKE ?
            AND tags_join.id = taggings_join.tag_id
            AND taggings_join.bookmark_id = bookmarks.id
            AND bookmarks.id = taggings.bookmark_id
            AND taggings.tag_id = tags.id
          )
          GROUP BY bookmarks.id
          ORDER BY ' + order_by + ' ' + order_direction,
                       "%#{search}%", "%#{search}%", "%#{search}%"], :page => page, :per_page => per_page
    end
    # Better would be:
    # 1. case insensitive find
    # 2. case sensitive write find result or new tag
    # 3. same for dashes (Open-Source vs opensource)
  end

  private

    def assign_tags
      if @tag_names = @tag_names.gsub(/^[\s|,]*/, '').gsub(/[\s|,]*$/, '').gsub(/(\s,|,\s)+/  , ',')
        # Remove whitespace+comma.. . ^ before ...         ^ after ...          ^ inbetween.
        # TODO: Max 100 Tags
        self.tags = @tag_names.split(/,+/).collect do |name|
          unless tag = Tag.find_by_name(name.strip.downcase)
            if tag = Tag.create(:name => name.strip)
              self.touch # Bookmark.updated_at
            end
          end
          tag # Return tag to block collect context
        end
      end
    end

end
