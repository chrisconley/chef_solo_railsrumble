# desc "Rake's default task."
# task :default => :test
#
# desc "Run chef-solo cookbook(s)."
# task :solo do
#   sh "chef-solo -l debug -c config/solo.rb -j config/dna.json"
# end
#
# desc "Test cookbook(s) syntax."
# task :test do
#   puts "** Testing your cookbooks for syntax errors"
#   Dir[ File.join(File.dirname(__FILE__), "cookbooks", "**", "*.rb") ].each do |recipe|
#     sh %{ruby -c #{recipe}} do |ok, res|
#       if ! ok
#         raise "Syntax error in #{recipe}"
#       end
#     end
#   end
# end

# SSH_OPTIONS={ 'BatchMode' => 'yes',
#   'CheckHostIP' => 'no',
#   'ForwardAgent' => 'yes',
#   'StrictHostKeyChecking' => 'no',
#   'UserKnownHostsFile' => '/dev/null' }.map{|k, v| "-o #{k}=#{v}"}.join(' ')
SSH_OPTIONS = {}
LOGIN = ENV['LOGIN'] || 'root'

task :host do |t|
  unless ENV['SERVER']
    raise "You must specify a host via the SERVER variable"
  end
end

task :sync => :host do |t|
  sh "rsync -Cavz --delete --exclude .git --rsh='ssh -l root #{SSH_OPTIONS}' #{File.dirname(__FILE__)}/ #{ENV['SERVER']}:/etc/chef"
end

desc "Bootstrap a new node to have the appropriate bits to run Chef"
task :bootstrap => [:sync, :host] do |t|
  ssh "/etc/chef/bootstrap.sh"
end

desc "Update an existing node to run the latest Chef configuration"
task :update => [:sync, :host] do |t|
  ssh "chef-solo -j /etc/chef/config/dna.json -l debug"
end

desc "SSH to the machine as root"
task :ssh => [:host] do |t|
  ssh
end

def ssh(cmd=nil)
  sh "ssh #{SSH_OPTIONS} -l #{LOGIN} #{ENV['SERVER']} #{cmd.nil? ? "" : "'#{cmd}'"}"
end
