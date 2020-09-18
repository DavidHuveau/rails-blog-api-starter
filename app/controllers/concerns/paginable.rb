module Paginable
  protected

  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 2).to_i
  end
  
  def pagination_data(links_path, collection)

    # "meta": {
    #   "pagination": {
    #     "page":
    #     "per_page": 25,
    #     "total_page": 6,
    #     "total_objects": 11
    #   }
    # }
    # current_page: collection.current_page,
    # per_page: collection.per_page,
    # total_entries: collection.total_entries,
    # total_pages: collection.total_pages


    {
      links: {
        first_page: send(links_path, page: 1),
        last_page: send(links_path, page: collection.total_pages),
        previous_page: send(links_path, page: collection.previous_page),
        next_page: send(links_path, page: collection.next_page)
      }
    }
  end
end