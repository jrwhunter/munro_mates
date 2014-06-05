module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Munro Mates"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Turns the name of the category of hill (Munros, etc) into
  #   a pattern for filtering hills in the database


end
