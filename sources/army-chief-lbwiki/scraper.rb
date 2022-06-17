#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class SlashedDMY < WikipediaDate
  def to_s
    date_en.to_s.split('/').reverse.join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Numm'
  end

  def table_number
    1
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name title start end].freeze
    end

    def date_class
      SlashedDMY
    end

    def raw_end
      super.gsub('-', '')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
