# frozen_string_literal: true
require_relative 'promotions_parser'

class Promotions
  def initialize(promos_json, promotions_parser_klass = PromotionsParser)
    @promotions_parser = promotions_parser_klass.new
    parse_promos_if_valid(promos_json)
  end

  def get_discount_rate(basket_value)
    rate = 0
    @value_rules.each do |rule|
      rate = rule[:discount] if basket_value >= rule[:value_required]
    end
    rate
  end

  def get_discounted_price(product_code, quantity)
    if promo_exists?(product_code) && has_min_quantity(product_code, quantity)
      discounted_price(product_code)
    end
  end

  private

  def parse_promos_if_valid(promos_json)
    promos_hash = @promotions_parser.parse_if_valid(promos_json)
    @value_rules = promos_hash[:value_rules]
    @volume_rules = promos_hash[:volume_rules]
  end

  def promo_exists?(product_code)
    @volume_rules[product_code]
  end

  def has_min_quantity(product_code, quantity)
    quantity >= volume_required(product_code)
  end

  def volume_required(product_code)
    @volume_rules.dig(product_code, :volume_required)
  end

  def discounted_price(product_code)
    @volume_rules[product_code][:discounted_price]
  end

end
