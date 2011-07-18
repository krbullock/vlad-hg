require 'rake/test_case' # from rake_remote_task
require 'vlad'
require 'vlad/mercurial'

class TestVladMercurial < Rake::TestCase
  def setup
    Rake::RemoteTask.set_defaults
    @scm = Vlad::Mercurial.new
    set :repository, "http://repo/project"
    set :deploy_to, "/path/to"
  end

  def test_checkout
    cmd = @scm.checkout 'default', '/path/to/scm'

    expected =
      "if [ ! -d .hg ]; then hg clone -r null http://repo/project .; fi " \
      "&& hg pull http://repo/project " \
      "&& hg update default"

    assert_equal expected, cmd
  end

  def test_export
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal :export, deploy_via.to_sym
    assert_equal 'hg archive -r default /path/to/release', cmd
  end

  def test_export_subrepos
    set :hg_subrepos, true
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg archive -S -r default /path/to/release', cmd
  end

  def test_revision
    # 0x0000_0000_0000 is the changeset ID for the root revision of all hg repos
    cmd = @scm.revision('000000000000')
    expected = "`hg identify -r 000000000000 | cut -f1 -d\\ `"
    assert_equal expected, cmd
  end

  def test_deploy_via
    set :deploy_via, :clone
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg clone /path/to/scm -r default /path/to/release', cmd

    set :deploy_via, :checkout
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg clone /path/to/scm -r default /path/to/release', cmd
end

end
