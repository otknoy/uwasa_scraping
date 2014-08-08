#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'

BASE_URI = 'http://wiki.chakuriki.net/index.php/'

def fetch_uwasa pagename
  uri = URI.escape(BASE_URI + pagename)
  doc = Nokogiri::HTML(open(uri))

  elements = extract_uwasa_elements doc
  elements = remove_no_order_list_heading elements
  elements_to_array(elements)
end

def extract_uwasa_elements doc
  content = doc.xpath('//div[@class="mw-content-ltr"]')
  elements = content.xpath('*')
  elements.select {|e| e.path =~ /(h[1-6]|ol)(\[[0-9]+\])*$/}
end

def remove_no_order_list_heading elements
  ret = []
  elements.each_cons(2) do |e1, e2|
    pat_h = /h[1-6](\[[0-9]+\])*$/
    pat_ol = /ol(\[[0-9]+\])*$/
    ret.push(e1, e2) if e1.path =~ pat_h and e2.path =~ pat_ol
  end
  ret
end

def elements_to_array elements
  ret = []
  elements.each_slice(2) do |h, ol|
    title = h.xpath('span[@class="mw-headline"]').text
    descriptions = ol.xpath('li').map do |li|
      li.text.strip.gsub(/\n+/, "\n")
    end
    ret.push({'title' => title, 'descriptions' => descriptions})
  end
  ret
end

if __FILE__ == $0
  pagenames = ['大阪市の駅']

  require 'json'

  pagenames.each do |p|
    uwasa_list = fetch_uwasa p
    open('results/' + p+'.json', 'w') do |f|
      f.write(JSON.pretty_generate(uwasa_list))
    end
  end
end
