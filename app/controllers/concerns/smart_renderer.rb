module SmartRenderer
  def render_or_error(instance, status = :created, options = {})
    if instance.errors.any?
      render status: :unprocessable_entity, json: { errors: instance.errors }
    else
      render status: status, json: instance.as_json(options)
    end
  end
end
