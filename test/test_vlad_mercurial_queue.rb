require 'test/vlad_test_case'
require 'vlad'
require 'vlad/mercurial_queue'

class TestVladMercurialQueue < MiniTest::Unit::TestCase

  def setup
    @scm = Vlad::MercurialQueue.new
    set :repository,      "http://repo/project"
    set :deploy_to,       "/path/to"
    set(:queue_repo)    { "#{repository}/.hg/patches" }
    set :queue_revision,  "tip"
  end

  def test_checkout
    cmd = @scm.checkout 'head', '/path/to/scm'

    expected = "if [ ! -d .hg ]; then hg init; fi " \
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
    cmd = @scm.export 'head', '/path/to/release'
    assert_equal 'hg archive -r qtip /path/to/release', cmd
  end

  def test_revision
    cmd = @scm.revision('default')
    expected = "`hg identify -r default | cut -f1 -d\\ `"
    assert_equal expected, cmd
  end

  def test_alternate_patch_queue_path
    set :queue_repo, 'http://repo/project-patched'

    # only need to test #checkout
    cmd = @scm.checkout 'head', '/path/to/scm'

    expected = "if [ ! -d .hg ]; then hg init; fi " \
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
    cmd = @scm.checkout 'head', '/path/to/scm'

    expected = "if [ ! -d .hg ]; then hg init; fi " \
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
