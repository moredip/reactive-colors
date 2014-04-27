require 'microstatic/rake'

desc "deploy to reactive-colors.thepete.net"
Microstatic::Rake.s3_deploy_task(:deploy) do |task|
  task.source_dir = File.expand_path("../dist",__FILE__)
  task.bucket_name = "reactive-colors.thepete.net"
end
