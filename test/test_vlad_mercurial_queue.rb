require 'rake/test_case' # from rake_remote_task
require 'vlad'
require 'vlad/mercurial_queue'

class TestVladMercurialQueue < MiniTest::Unit::TestCase

  def setup
    Rake::RemoteTask.set_defaults
    @scm = Vlad::MercurialQueue.new
    set :repository,      "http://repo/project"
    set :deploy_to,       "/path/to"
    set(:queue_repo)    { "#{repository}/.hg/patches" }
    set :queue_revision,  "tip"
  end

  def test_checkout
    cmd = @scm.checkout 'default', '/path/to/scm'

    expected =
      "if [ ! -d .hg ]; then hg clone -r null http://repo/project .; fi " \
      "&& if [ ! -d .hg/patches/.hg ]; then hg qinit -c; fi " \
      "&& hg qpop -a " \
      "&& hg pull http://repo/project " \
      "&& hg pull -R .hg/patches http://repo/project/.hg/patches " \
      "&& hg update default " \
      "&& hg update -R .hg/patches tip " \
      "&& hg qpush -a"

    assert_equal expected, cmd
  end

  def test_export
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg archive -r qtip /path/to/release', cmd
  end

  def test_export_via
    set :deploy_via, :checkout
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg clone /path/to/scm -r qtip /path/to/release', cmd
  end

  def test_export_subrepos
    set :hg_subrepos, true
    cmd = @scm.export 'default', '/path/to/release'
    assert_equal 'hg archive -S -r qtip /path/to/release', cmd
    set :hg_subrepos, false
  end

  def test_revision
    cmd = @scm.revision('default')
    expected = "`hg identify -r default | cut -f1 -d\\ `"
    assert_equal expected, cmd
  end

  def test_alternate_patch_queue_path
    set :queue_repo, 'http://repo/project-patched'

    # only need to test #checkout
    cmd = @scm.checkout 'default', '/path/to/scm'

    expected =
      "if [ ! -d .hg ]; then hg clone -r null http://repo/project .; fi " \
      "&& if [ ! -d .hg/patches/.hg ]; then hg qinit -c; fi " \
      "&& hg qpop -a " \
      "&& hg pull http://repo/project " \
      "&& hg pull -R .hg/patches http://repo/project-patched " \
      "&& hg update default " \
      "&& hg update -R .hg/patches tip " \
      "&& hg qpush -a"

    assert_equal expected, cmd
  end

  def test_queue_revision
    set :queue_revision, "deadbeefd00d"

    # only need to test #checkout
    cmd = @scm.checkout 'default', '/path/to/scm'

    expected =
      "if [ ! -d .hg ]; then hg clone -r null http://repo/project .; fi " \
      "&& if [ ! -d .hg/patches/.hg ]; then hg qinit -c; fi " \
      "&& hg qpop -a " \
      "&& hg pull http://repo/project " \
      "&& hg pull -R .hg/patches http://repo/project/.hg/patches " \
      "&& hg update default " \
      "&& hg update -R .hg/patches deadbeefd00d " \
      "&& hg qpush -a"

    assert_equal expected, cmd
  end

end
