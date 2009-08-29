require 'vlad'

module Vlad
  class Mercurial

    VERSION = '2.1.0'.freeze

    set :source, Vlad::Mercurial.new
    set :hg_cmd, "hg"

    ##
    # Returns the command that will check out +revision+ from the
    # repository into directory +destination+.  +revision+ can be any
    # changeset ID or equivalent (e.g. branch, tag, etc...)

    def checkout(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      # These all get executed after a "cd #{scm_path}"
      [ "if [ ! -d .hg ]; then #{hg_cmd} init; fi",
        "#{hg_cmd} pull #{repository}",
        "#{hg_cmd} update #{revision}"
      ].join(' && ')
    end

    ##
    # Returns the command that will export +revision+ from the repository into
    # the directory +destination+.
    # Expects to be run from +scm_path+ after Vlad::Mercurial#checkout

    def export(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      "#{hg_cmd} archive -r #{revision} #{destination}"
    end

    ##
    # Returns a command that maps human-friendly revision identifier +revision+
    # into a mercurial changeset ID.

    def revision(revision)
      "`#{hg_cmd} identify -r #{revision} | cut -f1 -d\\ `"
    end

  end
end
