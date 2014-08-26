# root = "/var/www/gitforms"
# working_directory root
# pid "#{root}/tmp/pids/unicorn.pid"
# stderr_path "#{root}/log/unicorn.log"
# stdout_path "#{root}/log/unicorn.log"

# # listen "/tmp/gitforms.sock"
# listen 'unix:/tmp/gitforms.sock', :backlog => 512
# worker_processes 3
# timeout 30

# # # Force the bundler gemfile environment variable to
# # # reference the capistrano "current" symlink
# # before_exec do |_|
# #   ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
# # end

# preload_app true
# if GC.respond_to?(:copy_on_write_friendly=)
#   GC.copy_on_write_friendly = true
# end

# before_fork do |server, worker|
#   old_pid = "#{server.config[:pid]}.oldbin"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end
