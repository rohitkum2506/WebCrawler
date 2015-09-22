# WebCrawlerIRA01
Simple ruby web crawler for IR assignment-01

Ruby version - ruby 2.2.1p85 (2015-02-26 revision 49769)

Libraries used :
1. Anemone - Ruby gem for spidering the web with lots of parsing and customising abilities. Used in webCrawler.rb for spidering the links.
2. Mechanize - Ruby gem for downloading a web page and parsing it.
3. open_uri_redirections - Ruby gem for enabling http's' calls. Its a dependency for Anemone and mechanize gem.
4. rubygem - Ruby gem for package management in ruby.

NOTE: The whole list could be found in gemfile

Pre-requisities for running the application:
1. Ruby version (>2.2.0).
2. RVM (ruby version manager) used for easy installation of ruby and version management. Ignore if ruby is already installated on machine.
3. bundler - Gem which downloads the required rubygems mentioned in gemfile.


Steps to run:
1. Ruby Installation : On any bash environment run '\curl -sSL https://get.rvm.io | bash -s stable --ruby'. 
   If you want to localise the setup, run the command from the project directory only.
   for more details please visit: 'https://rvm.io/rvm/install'.
2. check your ruby installation by typing 'ruby -v'. It should tell you the ruby version installed. 
3. Goto the project directory, WebCrawlerIRA01 and run 'bundle install'. This will download all the required libraries and dependencies.
4. to run the appliation use command format: 'ruby <filename.rb> <spaceSeperatedParameters>'. for example, if you want to run IndependentCrawler.rb use 'ruby IndependentCrawler.rb index'.
5. The results will be listed in respective .txt files.

NOTE: you have the flexibility to choose the keyphrase by passing the parameter at command line. If you don not pass any keyphrase, the crawler will run against the word "concordance".