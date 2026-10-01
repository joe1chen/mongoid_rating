# mongoid_rating

[![CI RSpec Test](https://github.com/joe1chen/mongoid_rating/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/joe1chen/mongoid_rating/actions/workflows/test.yml)

Star ratings for **Mongoid** documents. Each `rateable` field keeps its individual rates embedded in the rated
document together with a running count, sum and average, so showing a rating, the current user's rate, or sorting
by rating needs no extra queries. Rates can be integers or floats (4.5 stars), and a model can have any number of
independent rating fields.

This is the [DOGOnews](https://www.dogonews.com)-maintained fork of
[rs-pro/mongoid_rating](https://github.com/rs-pro/mongoid_rating) (upstream has been inactive since January 2014;
not archived). It is kept working on current Ruby, Rails, Mongoid and MongoDB versions.

## Supported versions

Tested on every push by the [GitHub Actions matrix](https://github.com/joe1chen/mongoid_rating/actions/workflows/test.yml)
([workflow](.github/workflows/test.yml)):

| Ruby | Rails | Mongoid | MongoDB |
|---|---|---|---|
| 2.7 | 6.1 | 7.5 | 6.0 |
| 3.0 | 6.1 | 8.0 | 6.0 |
| 3.1 | 7.0 | 8.1 | 7.0 |
| 3.2 | 7.1 | 8.1 | 7.0 |
| 3.2 | 7.2 | 9.0 | 7.0 |
| 3.3 | 7.2 | 9.0 | 8.0 |
| 3.4 | 8.0 | 9.0 | 8.0 |

The gemspec allows `mongoid >= 7.0, < 10`.

## Installation

This fork is not published to RubyGems; install it from GitHub:

```ruby
# Gemfile
gem 'mongoid_rating', github: 'joe1chen/mongoid_rating'
```

Requiring the gem adds the `rateable` macro to every `Mongoid::Document`; there is no module to include.

## Usage

### Declare rating fields

```ruby
class Post
  include Mongoid::Document

  rateable :rate                                   # 1..5, floats allowed, users may re-rate
  rateable :overall, range: -5..5
  rateable :stars, range: 1..10, float: false, rerate: false

  # only needed with rails_admin, so it does not complain about the embedded rates
  accepts_nested_attributes_for :rate_data
end
```

Options for `rateable field, options`:

| Option | Default | Meaning |
|---|---|---|
| `range:` | `1..5` | Allowed values; anything outside raises `RuntimeError, "bad vote value"` |
| `float:` | `true` | Store values as `Float` (otherwise `Integer`, input is `to_i`'d) |
| `rerate:` | `true` | Whether a rater may rate again (a re-rate replaces their previous rate). With `false` a second rate raises `RuntimeError, "can't rate"` |
| `validate:` | `true` | Validate the embedded rates with the parent document (see note below) |
| `format:` | `'%.1f'` (`'%d'` if `float: false`) | Format used by `fmt_<field>` |
| `no_rate:` | `'0.0'` (`'0'` if `float: false`) | What `fmt_<field>` returns when nothing has been rated |

Each `rateable :rate` defines these fields: `rate_count` (Integer), `rate_sum`, `rate_average` (Float) and the
embedded `rate_data` (`Mongoid::Rating::Rate` documents with `rater` (polymorphic), `value` and timestamps).

### Rate and unrate

```ruby
post.rate 5, user         # same as post.rate!(5, user)
post.unrate user          # same as post.unrate!(user); no-op if the user never rated
```

Counters and the average are updated atomically.

### Read ratings

```ruby
post.rate                 # => 3.75 (average; nil when there are no rates)
post.rate_count           # => 2
post.rate_sum             # => 7.5
post.rate_values          # => [4.5, 3.0]

post.rate_by(user)        # => 4.5 (this user's rate, or nil)
post.rate_by?(user)       # => true
post.did_rate?(user)      # => true
post.can_rate?(user)      # => true unless rerate: false and the user already rated

post.fmt_rate             # => "3.8"  formatted average, or the :no_rate value
post.fmt_rate(user)       # => "4.5"  the user's own rate if they rated (handy for the Raty JS plugin)
```

### Scopes

```ruby
Post.rate_by(user)        # documents rated by user
Post.rate_in(2..5)        # average within the range
Post.by_rate              # ordered by average, descending
Post.highest_rate         # rated documents only, ordered by average, descending
```

> Note: on Mongoid 8+ the parent document only re-validates embedded rates that are new or changed, so a
> document whose existing rate lost its rater (e.g. the user was deleted) stays valid; on Mongoid 7 it becomes
> invalid when `validate: true`. The rate itself is invalid in both cases.

## Development

```bash
# needs a MongoDB on localhost:27017 (e.g. docker run -p 27017:27017 mongo:8.0)
MONGOID_VERSION=9.0 RAILS_VERSION=8.0 bundle install
MONGOID_VERSION=9.0 RAILS_VERSION=8.0 bundle exec rspec spec
```

`MONGOID_VERSION` and `RAILS_VERSION` select the versions in the `Gemfile` (defaults: Mongoid 7.5, Rails 6.1 —
what dogo-web runs today). To add a combination to CI, add a row to `matrix.include` in
`.github/workflows/test.yml`.

## History

- **0.1.9+ (DOGOnews fork, 2026)** — GitHub Actions matrix up to Ruby 3.4 / Rails 8.0 / Mongoid 9.0 / MongoDB 8.0;
  mongoid dependency `>= 7.0, < 10`; specs on RSpec 3.13; Travis and Coveralls removed.
- **DOGOnews fork (2018–2022)** — mongoid-compatibility version checks, Mongoid 5–8 / Rails 5–7 support, optional
  rate validation (`validate: false`), database_cleaner-mongoid.
- **0.1.x (rs-pro / glebtv, 2013–2014)** — original gem, Mongoid 3/4.

## Credits

(c) 2013 glebtv, MIT license (see [LICENSE.txt](LICENSE.txt)).

Partially based on [mongoid_rateable](https://github.com/proton/mongoid_rateable), Copyright (c) 2011 Peter
Savichev (proton), MIT license.

[Contributors](https://github.com/joe1chen/mongoid_rating/graphs/contributors)
