module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titelize
    css_class = column == sort_column ? "sort_current sort_#{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort_by => column, :sort_direction => direction}, {:class => css_class}
  end
end
