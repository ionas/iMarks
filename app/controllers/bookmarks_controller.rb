class BookmarksController < ApplicationController

  # Thanks to: http://railscasts.com/episodes/210-customizing-devise
  before_filter :authenticate_user! # Devise

  # Thanks to: http://railscasts.com/episodes/228-sortable-table-columns
  helper_method :sort_column, :sort_direction

  def index # GET /bookmarks
    # sleep 1 # For debugging AJAX
    @bookmarks = Bookmark.search(search_string, params[:page], sort_column, sort_direction, per_page)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bookmarks }
      format.js
    end
  end

  def show # GET /bookmarks/1
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  def new # GET /bookmarks/new
    @bookmark = Bookmark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  def edit # GET /bookmarks/1/edit # NO XML
    @bookmark = Bookmark.find(params[:id])
    @bookmark.tag_names += ', ' unless @bookmark.tag_names.empty?
  end

  def create # POST /bookmarks
    @bookmark = Bookmark.new(params[:bookmark])

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to(bookmarks_url, :notice => 'Bookmark was successfully created.') }
        format.xml  { render :xml => @bookmark, :status => :created, :location => @bookmark }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update # PUT /bookmarks/1
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      if @bookmark.update_attributes(params[:bookmark])
        format.html { redirect_to(bookmarks_url, :notice => 'Bookmark was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy # DELETE /bookmarks/1
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to(bookmarks_url, :notice => 'Bookmark was successfully removed.') }
      format.xml  { head :ok }
    end
  end

  def confirm_destroy # GET /bookmarks/1/confirm_destroy # NO XML
    @bookmark = Bookmark.find(params[:id])
    respond_to do |format|
      format.html # confirm_destroy.html.erb
      format.js # confirm_destroy.html.js
    end
  end

  private

    def sort_column
      if params[:search].blank?
        %w[url updated_at].include?(params[:sort_by]) ? params[:sort_by] : 'updated_at'
      else
        %w[url updated_at].include?(params[:sort_by]) ? params[:sort_by] : nil
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'desc'
    end

    def search_string
      params[:search] = params[:search].to_s.gsub(/(\s)+/, ' ').strip # Remove whitespaces
    end

    def per_page
      if params[:per_page].blank?
        params[:per_page] = Bookmark.per_page
      end
      params[:per_page] = params[:per_page].to_i
      if params[:per_page] < Bookmark.per_page_min
        params[:per_page] = Bookmark.per_page_min
      elsif params[:per_page]> Bookmark.per_page_max
        params[:per_page] = Bookmark.per_page_max
      end
      params[:per_page]
    end

end
