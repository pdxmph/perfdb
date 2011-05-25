# Installing PerfDB on an Ubuntu Desktop

## Make sure you've got some core dependencies from Ubuntu:

    sudo apt-get install build-essential git-core curl

    sudo apt-get install bison openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf

    sudo apt-get install libcurl4-openssl-dev

    sudo apt-get install libmysqlclient16-dev


## Install rvm:

rvm provides a sandboxed Ruby installation for unprivileged users. It's a great way to keep Ruby up-to-date ahead of Ubuntu. Here are the instructions for installing rvm.

First, load the installer:

    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

Next, modify the user shell login script:

    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc

Now, reload the shell login script so the changes take effect:

    source ~/.bashrc

Now you can install Ruby 1.8.7:

    rvm install 1.8.7

Then make Ruby 1.8.7 the default Ruby version:

    rvm --default use 1.8.7

And you're all set to install Rails via your new rvm install:

    gem install rails --no-ri --no-rdoc

## Unpacking PerfDB and setting it up

PerfDB itself needs a MySQL database to talk to. Upload the PerfDB data into a MySQL server. By convention, the database should be named perfdb_development. 

Once the data is uploaded, you need to first update the libraries packaged with PerfDB. So unpack the PerfDB archive into the home directory of the user who installed rvm, cd into the perfdb directory, and update its package libraries:

    bundle install
    
Next, you need to make sure the database configuration is correct. cd into perfdb/configuration and edit the database.yml file.  

The section you want to make sure is correct is "development:" It will look like this:

	development:
	  adapter: mysql2
	  encoding: utf8
	  reconnect: false
	  database: perfdb_development
	  pool: 5
	  username: root
	  password: 
	  host: caladan.local

Adjust username, password and host as needed. 

Once you've updated your bundle and have the database configured, you can test the environment out. Go back to the top of the perfdb directory and try to open a console:

    rails console
    
You should get output like this:

    Loading development environment (Rails 3.0.7)
    ruby-1.8.7-p334 :001 > 
    
Next up, you should test the database connection by trying to retrieve a model:

    Editor.first
    
This ought to present output like this:

     => #<Editor id: 1, name: "Chris Saunders", last_name: "Saunders", first_name: "Chris", email: "csaunders@internet.com", group_id: 2, hourly_cost: 40.0, effort_multiplier: 0.5, multiplied: true> 
    ruby-1.8.7-p334 :002 > 
    
    
