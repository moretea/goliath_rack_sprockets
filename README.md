# Sprockets for Goliath

[![Build Status](https://secure.travis-ci.org/moretea/goliath_rack_sprockets.png)](http://travis-ci.org/moretea/goliath_rack_sprockets)


This gem makes it possible to use sprockets with Goliath.

## Installation & Prerequisites

* You should have a Gemfile with Goliath
* Add <code>goliath_rack_sprockets</code>


## Example usage

```ruby
require "goliath/rack/sprockets"

class SomeApp < Goliath::API
  use(Goliath::Rack::Sprockets, asset_paths: ["app/assets/javascripts", "app/assets/stylesheets"])
end
```

## License 

Sprockets for Goliath is distributed under the MIT license, for full details please see the LICENSE file.
