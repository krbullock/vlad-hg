require 'vlad'

module Vlad
  class Mercurial

    VERSION = '2.2.4'.freeze

    set :source,        Vlad::Mercurial.new
    set :hg_cmd,        'hg'
    set :revision,      'default'
    set :hg_subrepos,   false

    ##
    # Returns the command that will check out +revision+ from the
    # repository into directory +destination+.  +revision+ can be any
    # changeset ID or equivalent (e.g. branch, tag, etc...)

    def checkout(revision, destination)
      # These all get executed after a "cd #{scm_path}"
      [ "if [ ! -d .hg ]; then #{hg_cmd} clone -r null #{repository} .; fi",
        "#{hg_cmd} pull #{repository}",
        "#{hg_cmd} update #{revision}"
      ].join(' && ')
    end

    ##
    # Returns the command that will export +revision+ from the repository into
    # the directory +destination+.
    # Expects to be run from +scm_path+ after Vlad::Mercurial#checkout

    def export(revision, destination)
      case deploy_via.to_sym
      when :checkout, :clone
        "#{hg_cmd} clone #{scm_path} -r #{revision} #{destination}"
      else # :archive, :export (or whatever)
        "#{hg_cmd} archive#{' -S' if hg_subrepos} -r #{revision} #{destination}"
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
