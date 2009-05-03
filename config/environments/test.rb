config.cache_classes = true
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method = :test

config.gem "thoughtbot-factory_girl", :source => "http://gems.github.com/", :lib => "factory_girl"
config.gem "thoughtbot-shoulda", :source => "http://gems.github.com/", :lib => "shoulda"
config.gem "mocha"

