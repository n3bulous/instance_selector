# InstanceSelector

Remove the configuration pain when deploying to cloud servers.

When deploying applications with Capistrano, you need to itemize the servers for each role.  When you only have a server or two, this is easily managed. However, if you have many servers provisioned via a CM tool, keeping track of them becomes difficult.

By tagging servers with some meta data when they are created, you can filter
the server list to only the ones pertaining to the current deploy.

## Status

Currently, only EC2 instances are supported.

## Installation

Add this line to your application's Gemfile:

    gem 'instance_selector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install instance_selector

## Usage

By default, only running instances will be included in the results.  Overriding this restriction is in the TODO section.

### Standalone

    require 'instance_selector/connection'
    conn = InstanceSelector::Connection.factory(:aws)
    instances = connection.instances(:tags => {"Environment" => "staging", "Role" => "web"})

### With Capistrano

    require 'instance_selector/capistrano'
    instance_selector :app, :aws, :tags => {"Environment" => "staging", "Role" => "web"}

### Filters

http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeInstances.html

## TODO

- Tests
- filters (e.g., :filters => {"instance-state-name" => nil to clear the running instance filter})
- AWS
  - ELB support
    - attach/detach
    - selecting all instances in an ELB

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Kevin McFadden

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
