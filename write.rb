require 'yaml'

def write()
  YAML.load_file('library.yml')[2].sample
end