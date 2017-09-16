Stache.configure do |c|
  # This is probably the one you'll want to change
  # it defaults to app/templates
  c.template_base_path = "..."

  # This lets you indicate the name of a module that
  # namespaces all your view classes, useful, if you
  # have a naming conflict, such as with a mailer
  c.wrapper_module_name = "..."

  # N.B. YOU MUST TELL STACHE WHICH TO USE:
  c.use :mustache

  # Set it to true if template path should be included in
  # script's id tag as a underscored prefix. It can be
  # overwritten by an id param in `#template_include_tag`.
  c.include_path_in_id = false

  # Caching (new in 1.1.0, Mustache-only for now)
  # Any ActiveSupport::Cache should work fine.
  # If you enable this in development, you will lose automagical template reloading!
  c.template_cache = ActiveSupport::Cache::MemoryStore.new if Rails.env.production?
end

# or if the block style ain't yer thang, just:
Stache.template_base_path = File.join(Rails.root, "app", "shablon")
Stache.template_cache = ActiveSupport::Cache::MemoryStore.new if Rails.env.production?