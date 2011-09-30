# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :hg

Hoe.spec 'vlad-hg' do
  self.rubyforge_name = 'hitsquad'
  developer 'Kevin R. Bullock', 'kbullock@ringworld.org'
  extra_deps << ['vlad', '~> 2.0']
  self.hg_release_tag_prefix = 'v'
  self.rdoc_locations <<
    "rubyforge.org:/var/www/gforge-projects/hitsquad/#{remote_rdoc_dir}"
end

# vim: syntax=Ruby
