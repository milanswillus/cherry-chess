require 'xcodeproj'

project_path = '/Users/milanswillus/dev/ChessCompanion/ChessCompanion.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

group = project.main_group['ChessCompanion'] || project.main_group

['nn-1111cefa1111.nnue', 'nn-37f18f62d772.nnue'].each do |file_name|
  file_path = File.join('/Users/milanswillus/dev/ChessCompanion/ChessCompanion', file_name)
  
  file_ref = group.files.find { |f| f.path == file_name || f.path == file_path }
  unless file_ref
    file_ref = group.new_file(file_path)
  end
  
  resources_build_phase = target.resources_build_phase
  unless resources_build_phase.files.any? { |bf| bf.file_ref == file_ref }
    resources_build_phase.add_file_reference(file_ref)
    puts "Added #{file_name} to Resources build phase"
  end
end

project.save
puts "Successfully added NNUE files to project resources!"
