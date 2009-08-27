require 'vlad'

module Vlad
  class MercurialQueue

    set :source, Vlad::MercurialQueue.new
    set :hg_cmd, "hg"

    ##
    # Returns the command that will check out +revision+ from the
    # repository into directory +destination+.  +revision+ can be any
    # changeset ID or equivalent (e.g. branch, tag, etc...)

    def checkout(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      commands = []
      commands << "if [ ! -d #{destination}/.hg ]; then #{hg_cmd} init #{destination}; fi"
      commands << "if [ ! -d #{destination}/.hg/patches/.hg ]; then #{hg_cmd} qinit -R #{destination} -c; fi"
      commands << "#{hg_cmd} pull -R #{destination} #{repository}"
      commands << "#{hg_cmd} pull -R #{destination}/.hg/patches #{repository}/.hg/patches"
      commands << "#{hg_cmd} update #{revision}"
      commands << "#{hg_cmd} update -R #{destination}/.hg/patches"
      commands << "#{hg_cmd} qpush -a"
      commands.join(' && ')
    end

    ##
    # Returns the command that will export +revision+ from the repository into
    # the directory +destination+.
    # Expects to be run from +scm_path+ after Vlad::Mercurial#checkout

    def export(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      "#{hg_cmd} archive -R #{scm_path} -r #{revision} #{destination}"
    end

    ##
    # Returns a command that maps human-friendly revision identifier +revision+
    # into a mercurial changeset ID.

    def revision(revision)
      "`#{hg_cmd} identify -R #{repository} -r #{revision} | cut -f1 -d\\ `"
    end

  end
end
