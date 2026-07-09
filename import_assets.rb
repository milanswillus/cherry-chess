require 'fileutils'
require 'json'

src_dir = '/Users/milanswillus/dev/ChessCompanion/chess.com-boards-and-pieces/pieces/wood'
dest_dir = '/Users/milanswillus/dev/ChessCompanion/ChessCompanion/Assets.xcassets'

Dir.glob("#{src_dir}/*.png").each do |file|
  filename = File.basename(file)
  name = File.basename(file, '.png')
  
  imageset_dir = File.join(dest_dir, "#{name}.imageset")
  FileUtils.mkdir_p(imageset_dir)
  
  # Copy the image
  FileUtils.cp(file, File.join(imageset_dir, filename))
  
  # Generate Contents.json
  contents = {
    "images" => [
      {
        "filename" => filename,
        "idiom" => "universal",
        "scale" => "1x"
      },
      {
        "idiom" => "universal",
        "scale" => "2x"
      },
      {
        "idiom" => "universal",
        "scale" => "3x"
      }
    ],
    "info" => {
      "author" => "xcode",
      "version" => 1
    }
  }
  
  File.write(File.join(imageset_dir, 'Contents.json'), JSON.pretty_generate(contents))
  puts "Imported #{name}"
end

puts "Done!"
