$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Slammmdunk'

  app.provisioning_profile = 'MarkDev.mobileprovision'
  app.sdk_version = "5.0"

  app.info_plist['UIStatusBarStyle'] = "UIStatusBarStyleBlackOpaque"

  dirs = ['bubblewrap','sugarcube', 'teacup', 'styles', 'app']

  app.files = dirs.map{|d| Dir.glob(File.join(app.project_dir, "#{d}/**/*.rb")) }.flatten
  app.files_dependencies './app/app_delegate.rb' => './app/MCNavigationController.rb'

  app.vendor_project( "vendor/PFGridView", :xcode,
  :xcodeproj => "PFGridView.xcodeproj", :target => "PFGridView", :products => ["libPFGridView.a"],
  :headers_dir => "PFGridView")
end
