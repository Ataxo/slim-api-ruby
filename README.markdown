# Slim-API Ruby

Accessing SlimApi and work with clients, contracts, campaigns and statistics

## Instalation

Just in console

``` ruby
gem install slim-api-ruby
```

Or put into Gemfile

``` ruby
gem "slim-api-ruby"
```

and somewhere before use (not rails - they will require gem automaticaly)
``` ruby
require "slim-api"
```

## Initialization

Setup your config values

``` ruby
SlimApi.api_token = "YOUR_TOKEN"
```

## Working with Gem

You can access Main classes: Client, Contract, Campaign, Statistics, Category

### How classes works

[SlimApi documentation](http://slimapi.ataxo.com/doc/v1)

``` ruby
# Find some objects:
campaigns = SlimApi::Client.find
# you got [ <Client:..>, ... ] and choose first one
campaign = campaigns.first
# then you can ask for something
campaign.name #=> "Client Name"
campaign.id #=> 123456
```

Arguments from api is hash, this hash is saved by hashr directly into instance.
**Instance is still Hash, you can do all stuf like with normal hash.**

### Find
``` ruby

SlimApi::Client.find
#=> [ <Client:..>, ... ]

SlimApi::Campaign.find
#=> [ <Campaign:..>, ... ]

#to find client by id
clients = SlimApi::Client.find :id => 12345678
#=> [ <Client:..>, ... ]
# find will always return array!

#and find campaigns under one client
clients.first.campaigns
#=> [ <Campaign:..>, ... ]
```

### Hierarchy

look into documentation:
[SlimApi documentation](http://slimapi.ataxo.com/doc/v1)


### Statistics

In documentation you will find how to work with statistics api.

In gem you can use it same as in api:

``` ruby
SlimApi::Statistics.find :campaign_id => 1234, :'date.from' => Date.today - 10, :include => 'currency,partner_id,date', :order => 'date desc'
```

### Order 
 
You can order you find requests:

```ruby
SlimApi::Client.find :order => 'name desc'
#or multiple orders:
SlimApi::Client.find :order => 'name desc,email asc'
```

### Pagination

we added some functionality to array returned by method find

``` ruby
#default pagination setup
SlimApi.find_options
#=> { limit: 10, offset: 0 }
# and you can setup it by:
SlimApi.find_options = { limit: 20, offset: 0 }
#this is default configuration for all find methods, 
#but you can easily overwrite for one call it by adding limit/offset to find method:
SlimApi::Client.find limit: 15

#get first page of clients (in db is 25 clients mathching find, but you will get only 10 default find limit)
clients = SlimApi::Client.find
#=> [ <Client: 1..>, <Client: 2..>, <Client: 3..> .., <Client: 10..>]
clients.total_count
#=> 25 #this will tell you how many items can be getted
clients.has_next_page?
#=> true #this will tell you if you can do .next_page
clients.limit
#=> 10 #show find limit
clients.offset
#=> 0 #show find current offset
clients.page_count
#=> 3 #show how many pages you can get
clients.actual_page
#=> 1 #show current page

# this will return you new array with new data, but with offset changed to offset + limit
second_page_of_clients = clients.next_page
#=> [ <Client: 11..>, <Client: 12..>, <Client: 13..> .., <Client: 20..>]

second_page_of_clients.offset
#=> 10
second_page_of_clients.actual_page
#=> 2
```

## Copyright

Copyright (c) 2012 Ondrej Bartas. See LICENSE.txt for
further details.