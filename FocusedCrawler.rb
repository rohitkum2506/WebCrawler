require 'rubygems'
require 'mechanize'
require 'open_uri_redirections'


$linkArray = []
$validLinksArray = []
$agent = Mechanize.new

$keyPhrase = ARGV[0].to_s + ""
$validPageCount = 0
$totalPageCount = 0
$currentPageDepthLinkCount = 0
$nextPageDepthLinkCount = 0
$totalLinksCount = 0
$pageDepth = 1




STARTING_LINK = 'https://en.wikipedia.org/wiki/Hugh_of_Saint-Cher'

#This definition takes care of removing urls which contain 'main_page.'
def includesMainPageLink(link)
	link.to_s.downcase.include?"main_page"
end


def stripUnwantedLinksBasedOnCondition(links)
	#Regex takes care of avoiding links that :
	# 1. Do not start with en.wikipedia.org/wiki.
	# 2. Links that contain the ':'.
	# 3. Links that redirect to themselves ie. contain '#' in the url.
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

#Extract all the link from page adhering to given conditions using Xpath syntax.
def extractLinks(page)
	base_wiki_url = "https://en.wikipedia.org"
	links = page.search("//a")
	links = links.map{|item| item["href"]}

	#Appending with base_wiki_page to make it full fledged page.
	links = links.map{|link| base_wiki_url+link.to_s}

	return stripUnwantedLinksBasedOnCondition(links)
end

def writeLinksToFile()
	f = File.open("FocusedCrawler.txt", 'w')
	f.truncate(0)
	serialNum = 1
	proportion = $validPageCount.to_f/$totalPageCount
	f.write("Percentage of pages retrieved by focused crawling with the text '" + $keyPhrase +"' is " + proportion.round(3).to_s + "\n" + "\n")
	$validLinksArray.take(1000).each do |item|
		f.write(serialNum.to_s + ". " + item)
		f.write("\n")
		serialNum += 1
	end
	f.close()
end

def ValidatePage(link)
	$totalPageCount +=1
	htmlPage = $agent.get link
	if $keyPhrase.length == 0
		$keyPhrase = "concordance"
	end
	return htmlPage.body.downcase.include?$keyPhrase.downcase
end

def ValidateNumberOfLinksFound()
	if ($validPageCount >= 1000) || ($pageDepth == 5)
		writeLinksToFile()
		proportion = $validPageCount.to_f/$totalPageCount
		puts "Percentage of pages retrieved by focused crawling with the text '" + $keyPhrase +"' is " + proportion.round(3).to_s + "\n" + "\n"
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

def doCrawl
	index = 0
	while index<=$linkArray.count
		supervisorCrawler($linkArray[index])
		index += 1
	end
end

def supervisorCrawler(linkUrl)
	
	agent = $agent
	$totalLinksCount += 1
	#Gap of 1 second between subsequent http's' requests.
	sleep 1
	htmlPage = agent.get linkUrl

	if ValidatePage(htmlPage) 
		$validPageCount+=1
		linksFromPage = extractLinks(htmlPage)
		$nextPageDepthLinkCount += linksFromPage.count
		addToFIFO(linksFromPage)
		# $linkArray = $linkArray - [linkUrl]
		$validLinksArray.push(linkUrl)
		$validLinksArray = $validLinksArray.uniq		
		# puts "valid pages : " + $validPageCount.to_s + "     Total links count : "+ $totalLinksCount.to_s+ "      currentPageDepthLinkCount : "+ $currentPageDepthLinkCount.to_s +   "    Link array Size : " + $linkArray.count.to_s 
	end
	
	if $currentPageDepthLinkCount == $totalLinksCount 
		setPageDepthCount()
	end

	ValidateNumberOfLinksFound()
	
end

def startCrawl()
	printTime("start")	
	addToFIFO([STARTING_LINK])
	$currentPageDepthLinkCount +=1
	doCrawl()
end

startCrawl()