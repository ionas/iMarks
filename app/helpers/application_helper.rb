module ApplicationHelper
  
  def sortable(column, *args)
    options = args.extract_options!
    options[:label] ||= column.titelize
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    link_params = sort_options = {:sort_by => column, :sort_direction => direction}
    css_class = column == sort_column ? "sort_current sort_#{sort_direction}" : nil
    link_to options[:label], params.merge(sort_options), {:class => css_class}
  end
  
  def url_to_link(url)
    # More protocols/uri schemes:
    #   http://en.wikipedia.org/wiki/URI_scheme#Official_IANA-registered_schemes
    protocols = {
      'http' => 'http://',
      'https' => 'https://',
      'ftp' => 'ftp://',
      'chrome' => 'chrome://'
    }
    protocol = nil
    protocols.each do |protocol_key, uri_scheme_key| 
      if url =~ /#{uri_scheme_key}(.*)/
        protocol = protocol_key
      end
    end
    if protocol
      raw '<a href="' + url + '" class="protocol ' + protocol + '" title="' + url + '">' +
        url.sub(protocols[protocol], '') + '</a>'
    else
      raw '<a href="' + url + '" class="protocol unknown" title="' + url + '">' + url + '</a>'
    end
  end
  
end