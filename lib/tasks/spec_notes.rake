# only files with certain extensions are scanned
# notably NOT: Gemfile Gemfile.lock bin/some-script config/database.yml
ENV['SOURCE_ANNOTATION_DIRECTORIES'] ||= 'spec'
