module BoxesHelper

  def box_page_title(box)
    if box.present?
      "This is my Pencilbox &mdash; #{sanitize(@box.display_name)}".html_safe
    else
      @title
    end
  end
end
