# iMarks - Manage YOUR bookmarks in YOUR cloud.

* Setup the server anywhere you want, even at localhost or via DynDNS.
* Tags supported :).
* Use the chrome extension to search for bookmarks, update them or add new ones.
* For search "options" see [http://github.com/dougal/acts_as_indexed](http://github.com/dougal/acts_as_indexed) or enter lots of rubbish into the search field ;)



![iMarks in Action](http://img340.imageshack.us/img340/3368/imarks.jpg)



## Setup

* Tested on Ruby 1.8.7. I recommend Ruby Version Manager: [http://rvm.beginrescueend.com/](http://rvm.beginrescueend.com/)
* Requires ruby gems, 'bundler': [http://gembundler.com/](http://gembundler.com/) and rails 3
* "gem install bundler" (only use sudo if you do not use RVM)
* "gem install rails" (only use sudo if you do not use RVM)
* "cd iMarks" go to your application's root directory
* you might need "bundle" to install required gems
* "rake db:migrate" to create database schema
* Edit app/models/user.rb. Uncomment :registerable
* "rails s" to start the web server
* "open [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up)" 
* Edit app/models/users.rb comment :registerable and restart the webserver 
* "open [http://localhost:3000](http://localhost:3000)" to use the app
* For the chrome extension installation notes see "./_clients/README.rdoc"
* For now you may edit the iframe's src attribute to match it to the domain/IP you run iMarks server on



## Known Bugs

* "name already taken" for some tag savings (for instance if you supply a (new) tag name twice on bookmark creation)



## Alpha TODO


### Server

* Add/Edit form styles
* Autoadd "^" to params search (stands for "starts with")
* Remove "^" from params-search if its the only char


### Chrome Client

* Options: Set server IP
* Options: Set hotkey for saving



## 1.0 Beta TODO 


### Server

* Aftersave: On HTTP/HTTPS read the documents title on a short timeout if user given title is empty
* Presistant search result on next open (cookie)
* Test and document Heroku deployment (for other users)


### Chrome Client

* Presistant search result on next open + cookie storage (on next open of browser) (localstorage)
* Icon overhaul



## 1.1 TODO


## Server

* Large clickable backgrounds
* Hotkeys (arrows for the list, CMD/CTRL/META+S for saving)
* Test/Add Keyboard Navigation


### Web Client

* Stylesheets for standard web browsers
* Stylesheets for iPhone/Android



## 2.0 TODO


### Chrome Client

* Add clickable bookmark icon which reads http's/html <title> and applys this (optional) title to the bookmark. Copy chromes bookmark icon funcionality, add tags field.
* Option: disable Chromes internal bookmark star
* Autocompletion for tags
* Change icon depending on if the server is reachable
* Tags: Max 50 per Bookmark 
* Tags: Case in-sensitive "find", case sensitive create/update (e.g. "overwrite")


### Server

* Tags: Plural/singluar in-sensitive "find", update to whatever is specified


## 3.0 TODO


### Safari Client

* :-)


### Firefox Client

* :-)



## Future thoughts and ideas?!

* Add optional description field
* AJAX navigation
* Tags: Manage tags - rename tags, merge togather tags
* Categorisation
  * Bookmark referencing bookmarks (like Also see: and Similiar:) (Bookmark HABTM Bookmark)
  * Bookmark categories/collections (Like Tags)
  * Tags: Inverted Search - Tag as the main model, Bookmarks as dependencies
  * Tags as a tree: http://www.example.com /w tags: Example, Dummy and http://127.0.0.1 /w tags: Dummy, Localhost (also see acts_as_nested_set)
  * Advanced search by filtering tag tree - Closed:

	[+] Dummy
	[+] Example
	[+] Localhost
	
  * Advanced search by filtering tag tree - Fully expanded:
	
	[-] Dummy
	     - http://www.example.com
	     - http://127.0.0.1
	    [-] Example
	         - http://www.example.com
	    [-] Localhost
	         - http://127.0.0.1
	[-] Example
	     - http://www.example.com
	    [-] Dummy
	         - http://www.example.com
	[-] Localhost
	     - http://127.0.0.1
	    [-] Dummy
	        - http://127.0.0.1




# License

* iMarks is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. See: [http://creativecommons.org/licenses/by-nc-sa/3.0/](http://creativecommons.org/licenses/by-nc-sa/3.0/)
* Permissions beyond the scope of this license may be available at [http://github.com/ionas](http://github.com/ionas).
* iMarks License might change to something like GPL3 or like GPL3 with a non military clause (GPL incompatible), not sure yet.
* Contains source code which is licensed under multiple open source licenses like MIT/BSD/GPL.