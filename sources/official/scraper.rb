#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    POSITION_MAP = {
      'Prime Minister, Minister of State' => ['Prime Minister', 'Minister of State']
    }

    def name
      "#{given_name} #{family_name}"
    end

    def position
      raw_position.flat_map { |posn| POSITION_MAP.fetch(posn, posn) }
    end

    private

    def raw_position
      noko.css('.card-description p').map(&:text).map(&:tidy).reject(&:empty?)
    end

    #TODO: include these in output and check WD has them set
    def family_name
      noko.css('.member-name').text.tidy
    end

    def given_name
      noko.css('.member-lastname').text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.organizational-charts .card')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
