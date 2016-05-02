# InstanceSelector

Remove the configuration pain when deploying to cloud servers.

When deploying applications with Capistrano, you need to itemize the servers for each role.  When you only have a server or two this is easily managed, but keeping track of them becomes difficult if you have many servers provisioned via a CM tool or autoscaling.

By tagging servers with some meta data when they are created, you can filter
the server list to only the ones pertaining to the current deploy.

## Status

Currently, only EC2 instances are supported.

## Installation

Add this line to your application's Gemfile:

    gem 'instance_selector', require: false

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

    # Assign all web servers to the app role
    instance_selector :app, :aws, :tags => {"Environment" => "staging", "Role" => "web"}

    # assign the first returned instance tagged with the cron role to the database
    # for migration purposes
    instance_selector :db,
                      :aws,
                      :tags => {"Environment" => "staging", "Role" => "cron"},
                      role_options: { primary: true },
                      first_only: true

### Generic with Capistrano

    # Centralized instance selector config
    on :after, only: stages do
      @logger.log 1, "Selecting instances from the cloud"
      instance_selector :app, :aws, tags: {"Environment" => stage, "Role" => "web"}
      instance_selector :sidekiq, :aws, tags: {"Environment" => stage, "Role" => "sidekiq"}
      # NOTE: Only one cron host is supported! Tag appropriately.
      instance_selector :cron, :aws, tags: {"Environment" => stage, "CronRole" => "web"}
    end

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
