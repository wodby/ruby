# Verify refreshed system gems load after removing the inherited implementations.
require 'json'
require 'net/imap'
require 'rbconfig'

%w[json net-imap].each do |name|
  spec = Gem.loaded_specs.fetch(name)
  abort "#{name} was not installed in the system gem directory" unless spec.base_dir == Gem.default_dir
  abort "Old #{name} versions remain installed" unless Gem::Specification.find_all_by_name(name).size == 1
  puts "#{name}=#{spec.version}"
end

abort 'JSON round trip failed' unless JSON.parse(JSON.generate('ok' => true)).fetch('ok')
abort 'Net::IMAP did not load' unless defined?(Net::IMAP::ResponseParser)

# Default gems cannot be removed by gem cleanup; their files need explicit removal.
root = RbConfig::CONFIG.fetch('rubylibdir')
arch = RbConfig::CONFIG.fetch('archdir')
[File.join(root, 'json'), File.join(root, 'json.rb'), File.join(arch, 'json')].each do |path|
  abort "Inherited JSON implementation remains at #{path}" if File.exist?(path)
end

# System gem updates must not create root-owned files in the application bundle.
abort 'System gem updates created an application Gemfile' if File.exist?(File.join(Gem.dir, 'Gemfile'))
abort 'System gem updates created an application lockfile' if File.exist?(File.join(Gem.dir, 'Gemfile.lock'))
