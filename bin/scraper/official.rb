#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      "#{given_name} #{family_name}"
    end

    field :position do
      noko.css('.card-description p').map(&:text).map(&:tidy).reject(&:empty?)
    end

    private

    #TODO: include these in output and check WD has them set
    def family_name
      noko.css('.member-name').text.tidy
    end

    def given_name
      noko.css('.member-lastname').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      noko.css('.organizational-charts .card')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
