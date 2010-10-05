require "uri"

class Bookmark < ActiveRecord::Base

  acts_as_indexed :fields => [:url, :tag_names]

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
    if search.blank? # If its empty, we can use a simple find: LIKE "%%" not good.
      if order_by.blank?
        order_by = 'updated_at'
      end
      paginate :per_page => per_page, :page => page,
        :include => [:taggings, :tags],
        :order => order_by + ' ' + order_direction
    else
      if order_by
        with_query(search).paginate(:page => page, :per_page => per_page,
                                    :order => order_by + ' ' + order_direction)
      else # by indexer relevance
        with_query(search).paginate(:page => page, :per_page => per_page)
      end
    end
  end

  private

    def assign_tags
      if @tag_names = @tag_names.gsub(/^[\s|,]*/, '').gsub(/[\s|,]*$/, '').gsub(/(\s,|,\s)+/  , ',')
        # Remove whitespace+comma.. . ^ before ...         ^ after ...          ^ inbetween.
        # TODO: Max 100 Tags
        # TODO: case insensitive "find", case sensitive "overwrite"
        self.tags = @tag_names.split(/,+/).collect do |name|
          name = name.gsub(/"/, "\"")
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

# search = search.gsub(/"/, '\"').gsub(/\?/, '') # NO SQL Injects
# in_search = 'IN ("' + search.gsub(/(\s)+/, '", "') + '")'
# or_search = '= ("' + search.gsub(/(\s)+/, '" OR "') + '")'
# like_or_search = 'LIKE "%' + search.gsub(/(\s)+/, '%" OR "%') + '%"'
# like_xor_search = 'LIKE "%' + search.gsub(/(\s)+/, '%" XOR "%') + '%"'
# like_and_search = 'LIKE "%' + search.gsub(/(\s)+/, '%" AND "%') + '%"'
# bookmarks_search = '(bookmarks.url LIKE "%' +
#   search.gsub(/(\s)+/, '%" OR bookmarks.url LIKE "%') + '%")'
# tags_join_search = '(tags_join.name LIKE "%' +
#   search.gsub(/(\s)+/, '%" OR tags_join.name LIKE "%') + '%")'
# paginate_by_sql ['
#     SELECT bookmarks.id, bookmarks.url, bookmarks.updated_at, tags.name
#     FROM bookmarks
#     LEFT OUTER JOIN taggings ON taggings.bookmark_id = bookmarks.id
#     LEFT OUTER JOIN tags ON tags.id = taggings.tag_id
#     LEFT OUTER JOIN taggings AS taggings_join ON bookmarks.id = taggings_join.bookmark_id
#     LEFT OUTER JOIN tags AS tags_join ON taggings_join.tag_id = tags_join.id
#     WHERE (
#         ' + bookmarks_search + '
#         AND bookmarks.id = taggings.bookmark_id
#         AND taggings.tag_id = tags.id
#         AND tags.id = tags_join.id
#     ) OR (
#       tags_join.name ' + or_search + '
#       AND tags_join.id = taggings_join.tag_id
#       AND taggings_join.bookmark_id = bookmarks.id
#       AND bookmarks.id = taggings.bookmark_id
#       AND taggings.tag_id = tags.id
#     )
#     GROUP BY bookmarks.id
#     ORDER BY ?' + order_direction,
#   "#{order_by}"], :page => page, :per_page => per_page
#   # "#{search}%", "%#{search}%", "%#{search}%"], :page => page, :per_page => per_page

## OR

# http://www.databasejournal.com/sqletc/article.php/1578331/Using-Fulltext-Indexes-in-MySQL---Part-1.htm
# Do not forget: ALTER TABLE bookmarks ADD FULLTEXT (url); ALTER TABLE tags ADD FULLTEXT (name);
# Alternative: http://github.com/dougal/acts_as_indexed
#
# sql_search = search.gsub(/"/, '\"').gsub(/\?/, '') # NO SQL Injects
# or_search = '= ("' + sql_search.gsub(/(\s)+/, '" OR "') + '")'
# like_and_search_urls = 'LIKE "%' + sql_search.gsub(/(\s)+/, '%" AND bookmarks.url LIKE "%') + '%"'
# like_or_search_tags = 'LIKE "%' + sql_search.gsub(/(\s)+/, '%" OR tags.name LIKE "%') + '%"'
#
# paginate_by_sql ['
#     SELECT bookmarks.id, bookmarks.url, bookmarks.updated_at, tags.name,
#       MATCH (bookmarks.url, tags.name) AGAINST (? IN BOOLEAN MODE) AS relevance
#     FROM bookmarks
#       LEFT OUTER JOIN taggings ON taggings.bookmark_id = bookmarks.id
#       LEFT OUTER JOIN tags ON tags.id = taggings.tag_id
#     WHERE
#       (bookmarks.url ' + like_and_search_urls + ')
#       OR
#       (tags.name ' + like_or_search_tags + ')
#     GROUP BY bookmarks.id
#     ORDER BY ' + order_by + ' ' +  order_direction, "#{search}"],
#   :page => page, :per_page => per_page
