begin
  require 'yaml'
  require 'jasmine'
rescue LoadError
  task :jasmine do
    load 'jasmine/tasks/jasmine.rake'
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
