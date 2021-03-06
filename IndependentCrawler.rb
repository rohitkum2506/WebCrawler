require 'rubygems'
require 'mechanize'
require 'open_uri_redirections'


$linkArray = []
$crawledLinksArray = []
$agent = Mechanize.new
$index = -1
$pageCount = 0
$totalPageCount = 0
$currentPageDepthLinkCount = 0
$nextPageDepthLinkCount = 0
$totalLinksCount = 0
$pageDepth = 1



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
	$linkArray = $linkArray.uniq
end

def retrieveFromFIFO(i)
	$linkArray[i]
end

def printTime(str)
	puts "Time crawl " + str  + "ed : " + Time.new.inspect.to_s
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
	f = File.open("IndependentCrawler.txt", 'w')
	f.truncate(0)
	serialNum = 1
	$crawledLinksArray.take(1000).each do |item|
		f.write(serialNum.to_s + ". " + item)
		f.write("\n")
		serialNum += 1
	end
	f.close()
end

def deleteLinkFromArray(linkUrl)
	$linkArray = $linkArray - [linkUrl]
	if $linkArray.empty?
		puts "Sorry, there are no more links to crawl. Please change the seed and try again."
		printTime("end")
		exit
	end
end

def ValidateTheCrawl()
	if $crawledLinksArray.count >= 1000 || $pageDepth == 5
		writeLinksToFile()
		puts "Got enough links. Stopping the crawl and exiting."
		printTime("end")
		exit
	end
end

def setPageDepthCount
	$pageDepth+=1
	$currentPageDepthLinkCount += $nextPageDepthLinkCount
	$nextPageDepthLinkCount = 0
	puts "Page depth : " + $pageDepth.to_s
end

def supervisorCrawler(linkUrl)
	$index += 1
	agent = $agent
	$totalLinksCount += 1

	#Gap of 1 second between subsequent http's' requests.
	sleep 1
	htmlPage = agent.get linkUrl

	$pageCount+=1
	linksFromPage = extractLinks(htmlPage)
	$nextPageDepthLinkCount += linksFromPage.count
	addToFIFO(linksFromPage)
	$crawledLinksArray.push(linkUrl)	
	$crawledLinksArray = $crawledLinksArray.uniq


	if $currentPageDepthLinkCount == $totalLinksCount 
		setPageDepthCount()
	end

	ValidateTheCrawl()
	supervisorCrawler(retrieveFromFIFO($index))
end

def startCrawl()
	printTime("start")	
	addToFIFO([STARTING_LINK])
	$currentPageDepthLinkCount +=1
	supervisorCrawler(retrieveFromFIFO(0))
end

startCrawl()
