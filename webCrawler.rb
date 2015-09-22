require 'mechanize'
require 'rubygems'
require 'open-uri'
require 'anemone'

Data_dir = '/data'
base_wiki_url = 'https://en.wikipedia.org/'
starting_page = 'https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher'


def includesMainLink(link)
	link.to_s.downcase.include?"main_page"
end

def crawlWithAnemone()
	urlRegex = /^(https?:\/\/)?(en.wikipedia.org\/wiki\/)([a-zA-Z0-9\.\,\_\-\'\/\%])*\/?$/
	wikiLinksList = []
	index = 1
	f = File.open("webCrawler.txt", 'w')
	f.truncate(0)
	Anemone.crawl(starting_page, :depth_limit => 5, :obey_robots => true ) do |anemone|
	  	anemone.focus_crawl do |page| 
		  	
		  	page.links.delete_if{|link| urlRegex.match(link.to_s)==nil || includesMainLink(link.to_s)}
		  	page.links.each do |link|
		  		wikiLinksList.push(link.to_s)
		    	f.write((index).to_s+ ". "+ link.to_s)
		    	f.write("\n")
		    	index=index+1

			    if(wikiLinksList.count ==1000)
			    	f.close()
			    	exit
			    end
			end
	  	end
	end
end

crawlWithAnemone()
