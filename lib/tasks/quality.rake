desc 'Run all quality tests'
task :quality => ['quality:best_practices', 'quality:simplecov']

namespace :quality do
  desc 'Analyze for Rails best-practices'
  task :best_practices do
    system 'mkdir -p quality'
    system 'rails_best_practices -f html --with-git --output-file=quality/best_practices.html .'
  end
  task :bp => :best_practices

  desc 'Analyze for code coverage'
  task :simplecov do
    system 'rspec spec'
  end
end
