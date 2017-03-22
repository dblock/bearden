module ApplicationHelper
  def nav_class(element)
    class_string = 'nav-link'

    navigation_elements = {
      tags: tags_path
    }

    class_string << ' active' if navigation_elements[element] == request.path
    class_string
  end
end
