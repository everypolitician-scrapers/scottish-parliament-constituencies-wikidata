#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'wikidata/area'

query = <<-EOQ
  SELECT DISTINCT ?item WHERE { ?item wdt:P31 wd:Q7437892 .  }
EOQ

ids = EveryPolitician::Wikidata.sparql(query)
raise 'No ids' if ids.empty?

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
data = Wikidata::Areas.new(ids: ids).data
ScraperWiki.save_sqlite(%i(id), data)
