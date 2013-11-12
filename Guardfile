guard :spring, :rspec_cli => '--color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/factories/.+\.rb$}) { "spec/models" }
  watch('spec/spec_helper.rb') { "spec" }

  # Rails w/RSpec and FactoryGirl
  watch(%r{^app/(.+)\.rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end
  watch(%r{^app/(.*)\.erb$}) do |m|
    "spec/#{m[1]}#{m[2]}_spec.rb"
  end
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb"]
  end
  watch('app/controllers/application_controller.rb') do
    "spec/controllers"
  end
  watch(%r{^lib/(.+)\.rb$}) do |m|
    "spec/lib/#{m[1]}_spec.rb"
  end
  watch(%r{^spec/support/(.+)\.rb$}) do
    "spec"
  end
  watch('config/routes.rb') do
    "spec/routing"
  end

  # Capybara feature specs
  watch(%r{^app/views/(.+)/.*\.erb$}) do |m|
    "spec/features/#{m[1]}_spec.rb"
  end

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end

guard 'livereload' do
  watch(%r{app/views/.*/[^.][^/]+\.erb$})
  watch(%r{app/helpers/[^.][^/]+\.rb$})
  watch(%r{public/[^.][^/]+\.(css|js|html)$})
  watch(%r{config/locales/[^.][^/]+\.yml$})
  # Rails Assets Pipeline
  watch(%r{app/assets/stylesheets/globals\.css\.scss$})
  watch(%r{(app|lib|vendor)(/assets/\w+/([^.][^/]+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end
