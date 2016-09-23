require 'open-uri'
require 'yaml'
def read()
  url = "http://s3.amazonaws.com/viking_education/web_development/web_app_eng/enable.txt"
  library = Hash.new([])
  #add an array to the hash for each word length - 1st import showed most words between 2 and 24 characters
  (2..24).each { |num| library[num] = [] }
  #open the library url and add each word to appropriate array based on length
  open(url).each do |word|
    library[word.chomp.length] << word.chomp #.gsub(/"'"/, "")
  end
  # create a yaml file to store the library hash
  writefile = File.open("library.yml", "w")
  writefile.puts library.to_yaml
  writefile.close
  
end