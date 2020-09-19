module Paginable
  protected

  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 10).to_i
  end

  def with_pagination(collection)
    {
      data: collection,
      links: pagination_links(collection),
      meta: meta_data(collection)
    }
  end

  private

  def pagination_links(collection)
    {
      first_page: pagination_link(1),
      last_page: pagination_link(collection.total_pages),
      previous_page: collection.current_page > 1 ? pagination_link(collection.previous_page) : '',
      next_page: collection.current_page < collection.total_pages ? pagination_link(collection.next_page) : ''
    }
  end

  def pagination_link(page)
    url_for(page: page, per_page: per_page)
  end

  def meta_data(collection)
    {
      pagination: {
        current_page: collection.current_page,
        per_page: collection.per_page,
        total_pages: collection.total_pages,
        total_entries: collection.total_entries
      }
    }
  end
end
