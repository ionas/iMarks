module ApplicationHelper
  
  def sortable(column, *args)
    options = args.extract_options!
    options[:label] ||= column.titelize
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    link_params = sort_options = {:sort_by => column, :sort_direction => direction}
    css_class = column == sort_column ? "sort_current sort_#{sort_direction}" : nil
    link_to options[:label], params.merge(sort_options), {:class => css_class, :title => column }
  end
  
  def url_to_link(url, info, max_size = 44)
    # More protocols/uri schemes:
    #   http://en.wikipedia.org/wiki/URI_scheme#Official_IANA-registered_schemes
    protocols = {
      # TODO: Move this to the model
      # TODO: Add validation_exists! callbacks for http
      'H'    => 'http://',
      'HS'   => 'https://',
      'F'    => 'ftp://',
      'SF'   => 'sftp://',
      'D'    => 'data:',
      'RS'   => 'rsync://',
      'NEWS' => 'nntp://',
      'IRC'  => 'irc://',
      'CAL'  => 'webcal://',
      'VS'   => 'view-source:',
      'BOUT' => 'about:'
    }
    protocol = nil
    protocols.each do |protocol_key, uri_scheme_key| 
      if url =~ /#{uri_scheme_key}(.*)/
        protocol = protocol_key
      end
    end
    url_label = url    
    # kill possible trailing slashes
    url_label << '/' if url_label[-1].chr != '/'
    url_label.chop!
    # shorten the url_label
    if url_label.size > max_size
      url_label = url_label[0..max_size-1] + '&#x2026;'
    end
    title = info + ' &#13;' + url 
    if protocol
      raw '<a href="' + url + '" class="' + protocol + '" title="' + title + '">' +
        url_label.sub(protocols[protocol], '') + '</a>'
    else
      raw '<a href="' + url + '" class="unknown" title="' + title + '">' + url_label + '</a>'
    end
  end
  
end