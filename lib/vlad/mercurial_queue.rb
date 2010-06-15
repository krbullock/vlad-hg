require 'vlad'

module Vlad
  class MercurialQueue

    set :source, Vlad::MercurialQueue.new
    set :hg_cmd, "hg"
    set :queue_repo do
      "#{repository}/.hg/patches"
    end
    set :queue_revision, "tip"

    ##
    # Returns the command that will check out +revision+ from the
    # repository into directory +destination+.  +revision+ can be any
    # changeset ID or equivalent (e.g. branch, tag, etc...)

    def checkout(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      commands = []
      commands << "if [ ! -d .hg ]; then #{hg_cmd} init; fi"
      commands << "if [ ! -d .hg/patches/.hg ]; then #{hg_cmd} qinit -c; fi"
      commands << "#{hg_cmd} qpop -a"
      commands << "#{hg_cmd} pull #{repository}"
      commands << "#{hg_cmd} pull -R .hg/patches #{queue_repo}"
      commands << "#{hg_cmd} update #{revision}"
      commands << "#{hg_cmd} update -R .hg/patches #{queue_revision}"
      commands << "#{hg_cmd} qpush -a"
      commands.join(' && ')
    end

    ##
    # Returns the command that will export +revision+ from the repository into
    # the directory +destination+.
    # Expects to be run from +scm_path+ after Vlad::Mercurial#checkout

    def export(revision, destination)
      revision = 'tip' if revision =~ /^head$/i

      "#{hg_cmd} archive -r qtip #{destination}"
    end

    ##
    # Returns a command that maps human-friendly revision identifier +revision+
    # into a mercurial changeset ID.

    def revision(revision)
      "`#{hg_cmd} identify -r #{revision} | cut -f1 -d\\ `"
    end

  end
end
