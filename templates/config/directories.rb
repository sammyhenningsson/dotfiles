require 'config/constants'

$:.unshift APP_DIR

def sort_files(files)
  files.sort_by do |file|
    directory_priority(file) + file_priority(file)
  end
end

def directory_priority(file)
  case file
  when /\Alib/
    0
  when /\Ahelpers/
    10
  when /\Amodels/
    20
  when /\Apolicies/
    30
  when /\Acontrollers/
    40
  when /\Aserializers/
    50
  else
    60
  end
end


def file_priority(file)
  case File.basename(file)
  when /\Abase[\._]/
    0
  else
    9
  end
end

def require_ruby_files
  files = Dir[File.join('**', '*.rb')]
  sort_files(files).each do |file|
    # load all files with .rb extension in subfolders of api
    $logger&.debug "Require file: #{file}"
    require file
  end
end

if Dir.exist? SRC_DIR
  $:.unshift SRC_DIR

  Dir.chdir(SRC_DIR) do
    require_ruby_files
  end
end

Dir.chdir(APP_DIR) do
  require_ruby_files
end

