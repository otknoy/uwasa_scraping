#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'

if __FILE__ == $0
  pagename = '大阪市'
  uri = URI.escape('http://wiki.chakuriki.net/index.php/' + pagename)

  doc = Nokogiri::HTML(open(uri))
  content = doc.css('#bodyContent')

  headlines = content.xpath('//*[@class="mw-headline"]').map(&:text)[-3..-1]

  uwasa_list = []
  content.xpath('div/ol').each do |ol|
    uwasa = ol.xpath('li').map do |li|
      subject = li.text.split("\n")[0]
      article = li.text.split("\n")[1..-1].select{|e| e.size != 0}
      {'subject' => subject, 'articles' => article}
    end
    uwasa_list.push(uwasa)
  end

  
  headlines.zip(uwasa_list).each do |headline, uwasa|
    uwasa.each do |u|
      u['articles'].each do |a|
        puts "#{pagename},#{headline},#{u['subject']},#{a}"
      end
    end
  end
end
