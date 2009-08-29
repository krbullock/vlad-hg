require 'test/vlad_test_case'
require 'vlad'
require 'vlad/mercurial_queue'

class TestVladMercurialQueue < MiniTest::Unit::TestCase
  def setup
    @scm = Vlad::MercurialQueue.new
    set :repository, "http://repo/project"
    set :deploy_to, "/path/to"
  end

  def test_checkout
    cmd = @scm.checkout 'head', '/path/to/scm'

    expected = "if [ ! -d /path/to/scm/.hg ]; then hg init /path/to/scm; fi " \
               "&& if [ ! -d /path/to/scm/.hg/patches/.hg ]; then " \
                  "hg qinit -R /path/to/scm -c; fi " \
               "&& hg pull -R /path/to/scm http://repo/project " \
               "&& hg pull -R /path/to/scm/.hg/patches http://repo/project/.hg/patches "\
               "&& hg update tip " \
               "&& hg update -R /path/to/scm/.hg/patches " \
               "&& hg qpush -R /path/to/scm -a"

    assert_equal expected, cmd
  end

  def test_export
    cmd = @scm.export 'head', '/path/to/release'
    assert_equal 'hg archive -R /path/to/scm -r tip /path/to/release', cmd
  end

  def test_revision
    cmd = @scm.revision('tip')
    expected = "`hg identify -R http://repo/project -r tip | cut -f1 -d\\ `"
    assert_equal expected, cmd
  end
end

