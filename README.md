# Ruby Promotional Checkout   
[![Build Status](https://travis-ci.org/thisdotrob/ruby-promotional-checkout.svg?branch=master)](https://travis-ci.org/thisdotrob/ruby-promotional-checkout) [![Coverage Status](https://coveralls.io/repos/github/thisdotrob/ruby-promotional-checkout/badge.svg?branch=master)](https://coveralls.io/github/thisdotrob/ruby-promotional-checkout?branch=master)

* [About](#about)
* [Setup](#setup)
* [Usage](#usage)
* [Approach](#approach)
* [Classes](#classes)

## About
A checkout system in Ruby allowing a user to set promotional rules, scan items and calculate a total amount payable.


## Setup
1. Install [Ruby](https://www.ruby-lang.org/en/downloads/), [Bundler](http://bundler.io/) and [Git](https://git-scm.com/) if they are not installed already
2. Clone this repo: ```git clone git@github.com:thisdotrob/ruby-promotional-checkout.git```
3. Run ```bundle install```
4. Run the tests to make sure everything is okay: ```rspec```


## Usage
The promotional rules are contained in the ```promotional_rules.json``` file, which the user can edit in the following format to add or remove rules:

    {
      "value_rules": [
        {
          "value_required": 60,
          "discount": 0.1
        },
        {
          "value_required": 100,
          "discount": 0.2
        }
      ],
      "volume_rules": {
        "001": {
          "volume_required": 2,
          "discounted_price": 8.50
        },
        "003": {
          "volume_required": 20,
          "discounted_price": 15
        }
      }
    }

Once finished editing the promotional rules, the Checkout can be used as follows in your REPL of choice:

```
2.3.0 :001 > require "json"
2.3.0 :002 > require "./lib/checkout"
2.3.0 :003 > promotional_rules = File.read("promotional_rules.json")
2.3.0 :004 > co = Checkout.new(promotional_rules)
2.3.0 :005 > co.scan("001")
2.3.0 :006 > co.scan("002")
2.3.0 :007 > co.scan("001")
2.3.0 :008 > co.scan("003")
2.3.0 :009 > co.total
 => 73.76
```

## Approach
Based on the specifications provided, I made the following assumptions:
- Multiple promotional rules could be set by the user, but must be of two types:
  1. **Value based**: if the gross basket value is *X*, a discount of *Y%* is applied.
  2. **Volume based**: buy a certain quantity of *product X* and its price falls to *Y*.
- The promotional rules are passed as an argument to Checkout's initializer as a JSON string. I chose this approach over directly injecting a ruby object to make the solution more versatile (in case a front-end needed to be built later) and to make it easier for a user to modify and/or add promotional rules.
- The products sold are not modifiable by the end user (they exist as a constant in the Checkout class).

## Classes

|Class|Purpose|
|---|---|
|[Checkout](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/checkout.rb)|Main class, contains the list of products, responsible for scanning products and returning the total price.|
|[TotalCalculator](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/total_calculator.rb)|Calculates the total price for a given basket of goods and promotional rules, net of volume and value discounts.|
|[PriceCalculator](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/price_calculator.rb)|Calculates the price for a given product in the basket, based on the promotional rules and its quantity.|
|[Promotions](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/promotions.rb)|Contains the promotional rules, responsible for returning a discount rate based on basket value and discounted prices based on the quantities of promotional products in the basket.|
|[PromotionsParser](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/promotions_parser.rb)|Parses the promotional rules JSON string and instantiates a Promotions object.|
|[PromotionsValidator](https://github.com/thisdotrob/ruby-promotional-checkout/blob/master/lib/promotions_validator.rb)|Validates the promotional rules JSON string against a schema for required properties and types.|
