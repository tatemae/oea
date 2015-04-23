task copy_for_examples: :environment do
  assets = Dir.glob(File.join(Rails.root, 'public/assets/**/*'))
  regex = /(-{1}[a-z0-9]{32}*\.{1}){1}/
  example_assets_dir = File.join(Rails.root, 'examples/assets')

  remove_dir(example_assets_dir, force: true)

  assets.each do |file|
    next if File.directory?(file) || file =~ regex || ['.gz'].include?(File.extname(file))

    name = []
    source = file.split('/')
    name << source.pop
    while name.last != "assets"
      name << source.pop
    end
    
    name.pop # Remove 'assets'
    name.reverse!

    dst = File.join(example_assets_dir, name.join('/'))

    FileUtils.mkdir_p(File.dirname(dst)) unless File.exists?(File.dirname(dst))
    FileUtils.cp_r(file, dst, remove_destination: true)
  end
end