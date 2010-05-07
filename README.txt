= vlad-hg

* http://hitsquad.rubyforge.org/vlad-hg/
* http://rubyforge.org/projects/hitsquad/
* http://bitbucket.org/krbullock/vlad-hg/

== DESCRIPTION:

Mercurial support for Vlad. Using it is as simple as passing
<tt>:scm => :mercurial</tt> to Vlad when loading it up.

== FEATURES/PROBLEMS:

* Plug it in, it works.

* Supports deploying a patch queue on top of the deployed site (uses Mercurial
  Queues extension). See documentation below.

== SYNOPSIS

    # lib/tasks/vlad.rake
    begin
      require 'vlad'
      Vlad.load(:scm => :mercurial)
    rescue LoadError
    end

== REQUIREMENTS:

* Vlad[http://rubyhitsquad.com/Vlad_the_Deployer.html]

* Mercurial[http://mercurial.selenic.com/]

* Mercurial Queues[http://mercurial.selenic.com/wiki/MqExtension] extension
  enabled if using patch queue deployment (bundled with Mercurial, disabled by
  default)

== INSTALL:

* sudo gem install vlad-hg

== PATCH QUEUES:

+vlad-hg+ supports deploying from a patch queue repository on top of the main
site repository. This is useful e.g. for deploying a staging site with minor
configuration changes from the production site. To use it, pass <tt>:scm => 
:mercurial_queue</tt> to Vlad.load instead of <tt>:scm => :mercurial</tt>.

For example, say your repository is at http://example.com/hg/my-site and
you're deploying to http://my-site.example.com/. You want to set up a staging
site with your latest trunk code at http://my-staging-site.example.com/, so
that you can test your changes before deploying to the live site. You set up a
patch queue repository with the staging configuration like so:

    $ hg qinit -c                     # make the patch queue version-controlled
    $ hg qnew -m 'staging configuration' staging.patch
    ...configure for staging database, etc...
    $ hg qrefresh
    $ hg qcommit -m 'commit current patch queue'

You now have a repository in <working repo>/.hg/patches that contains your
configuration changes. You can clone this repository to your canonical
repository location:

    $ hg clone .hg/patches http://example.com/hg/my-site/.hg/patches   # first time
    $ hg push -R .hg/patches http://example.com/hg/my-site/.hg/patches # push subsequent changes

Now when you run <tt>rake vlad:update</tt>, it will update the repository on the
server and push all the patches in the queue (<tt>hg qpush -a</tt>) before
exporting the release directory.

+vlad-hg+ can also use a patch queue in a location other than
<repository>/.hg/patches. To do this, it adds the +queue_repo+ variable. For
example, say you want to keep your patch queue at
http://example.com/hg/my-staging-site. You would have this in
+config/deploy.rb+:

    set :repository, "http://example.com/hg/my-site"
    set :queue_repo, "http://example.com/hg/my-staging-site"

and you would push your patch queue like so:

    $ hg push -R .hg/patches http://example.com/hg/my-staging-site

To use a revision _of the patch queue_ other than +tip+, specify the
+queue_revision+ variable:

    set :queue_revision, "deadbeefd00d"

== LICENSE:

(The MIT License)

Copyright (c) 2009 Kevin Bullock and the rest of the Ruby Hit Squad

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
