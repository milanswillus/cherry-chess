require 'xcodeproj'

project_path = '/Users/milanswillus/dev/ChessCompanion/ChessCompanion.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Add ChessKit package
chesskit_pkg = project.root_object.package_references.find { |p| p.repositoryURL == 'https://github.com/chesskit-app/chesskit-swift' }
unless chesskit_pkg
  chesskit_pkg = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
  chesskit_pkg.repositoryURL = 'https://github.com/chesskit-app/chesskit-swift'
  chesskit_pkg.requirement = {
    'kind' => 'upToNextMajorVersion',
    'minimumVersion' => '0.5.0'
  }
  project.root_object.package_references << chesskit_pkg
end

# Add ChessKitEngine package
chesskit_engine_pkg = project.root_object.package_references.find { |p| p.repositoryURL == 'https://github.com/chesskit-app/chesskit-engine' }
unless chesskit_engine_pkg
  chesskit_engine_pkg = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
  chesskit_engine_pkg.repositoryURL = 'https://github.com/chesskit-app/chesskit-engine'
  chesskit_engine_pkg.requirement = {
    'kind' => 'upToNextMajorVersion',
    'minimumVersion' => '0.2.0'
  }
  project.root_object.package_references << chesskit_engine_pkg
end

# Link packages to target
frameworks_build_phase = target.frameworks_build_phase

['ChessKit', 'ChessKitEngine'].each do |pkg_name|
  unless target.package_product_dependencies.find { |d| d.product_name == pkg_name }
    pkg_dep = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
    pkg_dep.product_name = pkg_name
    
    if pkg_name == 'ChessKit'
      pkg_dep.package = chesskit_pkg
    else
      pkg_dep.package = chesskit_engine_pkg
    end
    
    target.package_product_dependencies << pkg_dep
    
    # Add to Frameworks Build Phase
    build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
    build_file.product_ref = pkg_dep
    frameworks_build_phase.files << build_file
  end
end

project.save
puts "Added Swift Packages to Xcode project!"
