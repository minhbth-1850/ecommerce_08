module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = I18n.t "logo"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def counter_per_page index, page, per_page
    page = page ? page.to_i : 1
    index + 1 + (page - 1) * per_page
  end
end
