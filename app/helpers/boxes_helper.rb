module BoxesHelper

  def box_page_title(box)
    if @page_title.present?
      @page_title
    elsif box.present?
      "This is my Pencilbox &mdash; #{sanitize(@box.display_name)}".html_safe
    else
      "Not found!"
    end
  end
end
