vcloud-ruby
===========

DESCRIPTION
-----------

Ruby bindings to the VMware vCloud Director REST API

This is a work in progress, but it currently supports enough functionality to perform the entire Hello vCloud example in the [vCloud API Guide](http://www.vmware.com/pdf/vcd_15_api_guide.pdf).


INSTALL
-------

<pre>gem install vcloud</pre>


USAGE
-----

The examples/hello_vcloud.rb file demonstrates basic usage of the gem, for example...

```
require 'vcloud'
@session = VCloud::Client.new("https://my.vcloud.local/api/"), '1.5')
@session.login('someuser@someorg', 'secretp@ssw0rd)
@org = @session.get_org_from_name('myorg')
@catalog = @org.get_catalog_from_name('TestCatalog')
@vdc     = @org.get_vdc_from_name('TestVDC')
@catalog_item = @catalog.get_catalog_item_from_name('TestLinuxTemplate')
```

...and so on

CONTRIBUTE
----------
* Fork the project
* Make your feature addition or bug fix.
* Add tests
* Commit, do not modify with rakefile or version, we'll handle this
* Send a pull request

LICENSE
-------
(The MIT License)

Copyright © 2012 Diebold, Inc. [http://www.diebold.com](http://www.diebold.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.