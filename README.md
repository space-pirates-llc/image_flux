# ImageFlux

[![Gem](https://img.shields.io/gem/v/image_flux.svg)](https://rubygems.org/gems/image_flux)
[![CircleCI](https://img.shields.io/circleci/project/github/space-pirates-llc/image_flux.svg)](https://circleci.com/gh/space-pirates-llc/image_flux)
[![Coverage Status](https://coveralls.io/repos/github/space-pirates-llc/image_flux/badge.svg?branch=master)](https://coveralls.io/github/space-pirates-llc/image_flux?branch=master)

URL builder for [ImageFlux](https://www.sakura.ad.jp/services/imageflux/)®.

WIP: Provide API client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image_flux'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install image_flux

## Usage

### Generate resize url for a path

```ruby
require 'image_flux'
origin = ImageFlux::Origin.new(domain: 'example.imageflux.jp')

origin.image_url("/original.jpg', width: 100)
# => https://example.imageflux.jp/c/w=100/original.jpg
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/space-pirates-llc/image_flux>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Notation

- ImageFlux is a registered trademark of [SAKURA Internet Inc](https://www.sakura.ad.jp/).
- Regarding the use of this gem, pixiv Inc and SAKURA Internet Inc makes no responsibility.
