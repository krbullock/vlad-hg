= vlad-hg

* http://vladhg.rubyforge.org/
* http://bitbucket.org/krbullock/vlad-hg/
* http://rubyforge.org/projects/vladhg/

== DESCRIPTION:

Mercurial support for Vlad. Using it is as simple as passing
<tt>:scm => :mercurial</tt> to Vlad when loading it up (see Synopsis below).

== FEATURES/PROBLEMS:

* Plug it in, it works.

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

== INSTALL:

* sudo gem install vlad-hg

== LICENSE:

(The MIT License)

Copyright (c) 2009 Ryan Davis and the rest of the Ruby Hit Squad

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
