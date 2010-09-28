class BookmarksController < ApplicationController

  before_filter :authenticate # Also Add 1. Data Encryption by Public/Private Key 2. SSL?

  # Thanks to: http://railscasts.com/episodes/228-sortable-table-columns
  helper_method :sort_column, :sort_direction

  # GET /bookmarks
  # GET /bookmarks.xml
  def index
    params[:search] = params[:search].to_s.strip # Remove wrapping whitespaces
    @bookmarks = Bookmark.search(params[:search], params[:page], sort_column, sort_direction, per_page)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bookmarks }
      format.js {
        render :update do |page|
          # 'page.replace' will replace full "results" block...works for this example
          # 'page.replace_html' will replace "results" inner html...useful elsewhere
          page.replace_html 'bookmarks', :partial => 'bookmark'
        end
      }
    end

  end

  # GET /bookmarks/1
  # GET /bookmarks/1.xml
  def show
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def new
    @bookmark = Bookmark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  # GET /bookmarks/1/edit
  def edit
    @bookmark = Bookmark.find(params[:id])
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    @bookmark = Bookmark.new(params[:bookmark])

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully created.') }
        format.xml  { render :xml => @bookmark, :status => :created, :location => @bookmark }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bookmarks/1
  # PUT /bookmarks/1.xml
  def update
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      if @bookmark.update_attributes(params[:bookmark])
        format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.xml
  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to(bookmarks_url) }
      format.xml  { head :ok }
    end
  end

  protected

    # Thanks to: http://railscasts.com/episodes/82-http-basic-authentication
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == 'joe' && password = 'put'
      end
    end

  private
  
    def sort_column
      # Does not work with tag_names
      # Bookmark.column_names.include?(params[:sort_by]) ? params[:sort_by] : 'updated_at'
      %w[url updated_at].include?(params[:sort_by]) ? params[:sort_by] : 'updated_at'
    end

    def sort_direction
      %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'desc'
    end
    
    def per_page
      params[:per_page] = params[:per_page].to_i
      # ((1..Bookmark.per_page_max) === params[:per_page]) ? params[:per_page] : Bookmark.per_page_max
      if params[:per_page] < Bookmark.per_page_min
        params[:per_page] = Bookmark.per_page_min
      end
      if params[:per_page]> Bookmark.per_page_max
        params[:per_page] = Bookmark.per_page_max
      end
      params[:per_page]
    end

end
