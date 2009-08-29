require 'test/vlad_test_case'
require 'vlad'
require 'vlad/mercurial'

class TestVladMercurial < MiniTest::Unit::TestCase
  def setup
    @scm = Vlad::Mercurial.new
    set :repository, "http://repo/project"
    set :deploy_to, "/path/to"
  end

  def test_checkout
    cmd = @scm.checkout 'head', '/path/to/scm'

    expected = "if [ ! -d .hg ]; then hg init; fi " \
               "&& hg pull http://repo/project " \
               "&& hg update tip"

    assert_equal expected, cmd
  end

  def test_export
    cmd = @scm.export 'head', '/path/to/release'
    assert_equal 'hg archive -r tip /path/to/release', cmd
  end

  def test_revision
    # 0x0000_0000_0000 is the changeset ID for the root revision of all hg repos
    cmd = @scm.revision('000000000000')
    expected = "`hg identify -r 000000000000 | cut -f1 -d\\ `"
    assert_equal expected, cmd
  end
end

