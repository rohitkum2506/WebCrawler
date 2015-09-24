# WebCrawlerIRA01
Simple ruby web crawler for IR assignment-01

Ruby version - ruby 2.2.1p85 (2015-02-26 revision 49769)

Libraries used :
1. Mechanize - Ruby gem for downloading a web page and parsing it.
2. open_uri_redirections - Ruby gem for enabling http's' calls. Its a dependency for mechanize gem.
3. rubygem - Ruby gem for package management in ruby.

NOTE: The whole list could be found in gemfile

Pre-requisities for running the application:
1. Ruby version (>2.2.0).
2. RVM (ruby version manager) used for easy installation of ruby and version management. Ignore if ruby is already installated on machine.
3. bundler - Gem which downloads the required rubygems mentioned in gemfile.


Steps to run:
NOTE1 : There are two version for focused crawler (FocusedCrawler1.rb and FocusedCrawler2.rb) as there was confusion in the class about the number of links that had to be crawled. FocusedCrawler.rb crawls to get 1000 relevant urls where relevance means finding the text passed in the document. FocusedCrawlerFor1000Links.rb crawls to get relevant urls in any 1000 unique urls which are relevant.
IndependentCrawler deals with crawling without classifier.

NOTE2 : There is flexibility to change the keyphrase by passing the keyphrase from command line in FocusedCrawler.rb. Although if you don not pass any keyphrase, the crawler will run against the word "concordance" for focused crawler.

1. Ruby Installation : On any bash environment run '\curl -sSL https://get.rvm.io | bash -s stable --ruby'. 
   If you want to localise the setup, run the command from the project directory only.
   for more details please visit: 'https://rvm.io/rvm/install'.
2. Check your ruby installation by typing 'ruby -v'. It should tell you the ruby version installed. 
3. Do 'gem install bundler'.
4. Goto the project directory, WebCrawlerIRA01 and run 'bundle install'. This will download all the required libraries and dependencies.
5. To run the application use command format: 'ruby <filename.rb> <spaceSeperatedParameters>'. for example, if you want to run FocusedCrawler.rb use 'ruby FocusedCrawler.rb concordance'. You do not need any parameter for IndependentCrawler.rb
6. The results will be listed in respective .txt files.

References:
1. http://www.tutorialspoint.com/ruby/ - For Ruby syntax.
