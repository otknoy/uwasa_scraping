#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'

if __FILE__ == $0
  pagename = ' 高槻市'
  # uri = URI.escape('http://wiki.chakuriki.net/index.php/' + pagename)

  # doc = Nokogiri::HTML(open(uri))
  doc = Nokogiri::HTML(open('takatsuki_city.html'))

  content = doc.xpath('//div[@class="mw-content-ltr"]')

  elements = content.xpath('*')
  uwasa_elements = elements.select do |e|
    e.path =~ /(h[1-6]|ol)/
  end

  uwasa_elements.each_slice(2) do |h, ol|
    puts h.xpath('span[@class="mw-headline"]').text
    puts
    ol.xpath('li').each do |li|
      puts li.text.strip.split(/\n+/)
      puts
    end
    puts
  end

  # content.xpath('//*[@class="mw-headline"]').each do |headline|
  #   puts headline.xpath(
  # end
end
