require 'mechanize'
require 'rubygems'
require 'open-uri'
require 'anemone'

Data_dir = '/data'
base_wiki_url = 'https://en.wikipedia.org/'
starting_page = 'https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher'


def createCrawler()
	agent = Mechanize.new
	starting_page = 'https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher'
	page = agent.get starting_page
	links = page.search("//a")
	linkList = []

	links.each do |link|
		if(!link.include? "Main_Page")
			linkList.push(link)
		end
	end
	
	count = 0

	linkList.each do |link|
		count = count +1
		puts link
		if link.attributes["href"]!=nil
			puts link.attributes["href"].value
			puts "##############################"
		end
		if count==10
			return ""
		end
	end
end

def crawlWithAnemone()
	urlRegex = /^(https?:\/\/)?(en.wikipedia.org\/wiki\/)([a-zA-Z0-9\.\,\_\-\'\/\%])*\/?$/
	wikiLinksList = []
	index = 0
	Anemone.crawl("https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher", :depth_limit => 5, :obey_robots => true ) do |anemone|
	  anemone.focus_crawl do |page| 
	  	puts page.depth
	  	page.links.each do |link|
	  		linkIsMainPage = link.to_s.downcase.include?"main_page"
		  	if(urlRegex.match(link.to_s)!=nil && !linkIsMainPage)
		    	wikiLinksList.push(link.to_s)
		    	puts wikiLinksList[index]
		    	index=index+1
		    end
		    sleep 60
		    if(wikiLinksList.count ==1000)
		    	exit
		    end
		end
	  end
	end
end

# def crawlWithAnemone()
# 	urlRegex = /^(https?:\/\/)?(en.wikipedia.org\/wiki\/)([a-zA-Z0-9\.\_\-\'])*\/?$/
# 	a = []
# 	Anemone.crawl("https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher", :depth_limit => 5, :obey_robots => true ) do |anemone|
# 	  anemone.focus_crawl do |page| 
# 	  	page.links.slice(0..1)
# 	  	a = page.links
# 	  end
# 	end
# end

# def printCode()
# 	LList  = createCrawler()
# 	count = 0
# 	asdList.each do |link|
# 		count = count +1
# 		puts link.attributes["href"].value
# 		if count==10
# 			return
# 		end
# 	end
# end

crawlWithAnemone()
