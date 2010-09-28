module ApplicationHelper
  
  def sortable(column, *args)
    options = args.extract_options!
    options[:label] ||= column.titelize
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    link_params = sort_options = {:sort_by => column, :sort_direction => direction}
    css_class = column == sort_column ? "sort_current sort_#{sort_direction}" : nil
    link_to options[:label], params.merge(sort_options), {:class => css_class}
  end
  
end