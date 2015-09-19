require 'rubygems'
require 'mechanize'
require 'open-uri'


$linkArray = []
$agent = Mechanize.new
$index = -1
Data_dir = '/data'

STARTING_LINK = 'https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher'

def includesMainPageLink(link)
	link.to_s.downcase.include?"main_page"
end

def includesLinktoSelf(link)
	link.to_s.downcase.include?':'.to_s
end


def stripUnwantedLinksBasedOnCondition(links)
	urlRegex = /^(https?:\/\/)?(en.wikipedia.org\/wiki\/)([a-zA-Z0-9\.\,\_\-\'\/\%])*\/?$/
	links.delete_if{|link|  urlRegex.match(link.to_s)==nil}
	links.delete_if{|link| includesMainPageLink(link)}
	return links
end


def addToFIFO(links)
	$linkArray = $linkArray.concat links
end

#//TODO
def retrieveFromFIFO(i)
	$linkArray[i]
end

def extractLinks(page)
	base_wiki_url = "https://en.wikipedia.org"
	links = page.search("//a")
	links = links.map{|item| item["href"]}

	#Appending with base_wiki_page to make it full fledged page.
	links = links.map{|link| base_wiki_url+link.to_s}

	#delete unneccesary links according to problem statement. TODO Customize it.
	return stripUnwantedLinksBasedOnCondition(links)
end

def writeLinksToFile()
	f = File.open("newlink.txt", 'w')
	f.truncate(0)
	serialNum = 1
	$linkArray.each do |item|
		f.write(serialNum.to_s + ". " + item)
		f.write("\n")
		serialNum += 1
	end
	f.close()
end

def ValidatePage(link)
	htmlPage = $agent.get STARTING_LINK
	return htmlPage.body.include?"index"
end

def SupervisorCrawler(seedLink)
	$index += 1
	agent = $agent
	htmlPage = agent.get STARTING_LINK
	
	if ValidatePage(htmlPage) 
		linksFromPage = extractLinks(htmlPage)
		addToFIFO(linksFromPage)
	end

	if $linkArray.count>=1000
		writeLinksToFile()
		puts "got 1000 links.stopping the crawl and exiting."
		exit
	end
	SupervisorCrawler($linkArray[$index])
end

def startCrawl()
	SupervisorCrawler(STARTING_LINK)
end

startCrawl()
