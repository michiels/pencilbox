module BoxesHelper

  def box_page_title(box)
    if @folder.present? && @articles.any?
      @folder.path[1..-1].humanize
    elsif @page_title.present?
      @page_title
    elsif box.present?
      "This is my Pencilbox &mdash; #{sanitize(@box.display_name)}".html_safe
    else
      "Not found!"
    end
  end
end
