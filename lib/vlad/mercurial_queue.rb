require 'vlad'

module Vlad
  class MercurialQueue

    set :source,                Vlad::MercurialQueue.new
    set :hg_cmd,                'hg'
    set :revision,              'default'
    set :hg_subrepos,           false
    set(:queue_repo)            { "#{repository}/.hg/patches" }
    set :queue_revision,        'default'

    ##
    # Returns the command that will check out +revision+ from the
    # repository into directory +destination+.  +revision+ can be any
    # changeset ID or equivalent (e.g. branch, tag, etc...)

    def checkout(revision, destination)
      commands = []
      commands <<
        "if [ ! -d .hg ]; then #{hg_cmd} clone -r null #{repository} .; fi"
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
      case deploy_via.to_sym
      when :checkout, :clone
        "#{hg_cmd} clone #{scm_path} -r qtip #{destination}"
      else # :archive, :export (or whatever)
        "#{hg_cmd} archive#{' -S' if hg_subrepos} -r qtip #{destination}"
      end
    end

    ##
    # Returns a command that maps human-friendly revision identifier +revision+
    # into a mercurial changeset ID.

    def revision(revision)
      "`#{hg_cmd} identify -r #{revision} | cut -f1 -d\\ `"
    end

  end
end
