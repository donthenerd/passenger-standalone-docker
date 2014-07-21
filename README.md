# A Docker base image for Ruby, Python, Node.js and Meteor web apps

<center><img src="http://blog.phusion.nl/wp-content/uploads/2012/07/Passenger_chair_256x256.jpg" width="196" height="196" alt="Phusion Passenger"> <img src="http://blog.phusion.nl/wp-content/uploads/2013/11/docker.png" width="233" height="196" alt="Docker"></center>

Passenger-standalone-docker is a [Docker](http://www.docker.io) image meant to serve as a good base for **Ruby, Python, Node.js and Meteor** web app images. In line with [Phusion Passenger](https://www.phusionpassenger.com/)'s goal, passenger-docker's goal is to make Docker image building for web apps much easier and faster.

Why is this image called "passenger"? It's to represent the ease: you just have to sit back and watch most of the heavy lifting being done for you. Passenger-docker is part of a larger and more ambitious project: to make web app deployment ridiculously simple, to heights never achieved before.

**Relevant links:**
 [Github](https://github.com/phusion/passenger-docker) |
 [Docker registry](https://index.docker.io/u/phusion/passenger-full/) |
 [Discussion forum](https://groups.google.com/d/forum/passenger-docker) |
 [Twitter](https://twitter.com/phusion_nl) |
 [Blog](http://blog.phusion.nl/)

---------------------------------------

**Table of contents**

 * [Why use passenger-standalone-docker?](#why_use)
 * [About passenger-standalone-docker](#about)
   * [What's included?](#whats_included)
   * [Memory efficiency](#memory_efficiency)
   * [Image variants](#image_variants)
 * [Inspecting the image](#inspecting_the_image)
 * [Using the image as base](#using)
   * [Getting started](#getting_started)
   * [The `app` user](#app_user)
   * [Using Nginx and Passenger](#nginx_passenger)
     * [Adding your web app to the image](#adding_web_app)
     * [Configuring Nginx](#configuring_nginx)
     * [Setting environment variables in Nginx](#nginx_env_vars)
   * [Selecting a default Ruby version](#selecting_default_ruby)
 * [Administering the image's system](#administering)
   * [Inspecting the status of your web app](#inspecting_web_app_status)
   * [Logs](#logs)
 * [Building the image yourself](#building)
 * [Conclusion](#conclusion)

---------------------------------------

<a name="why_use"></a>
## Why use passenger-docker?

Why use passenger-docker instead of doing everything yourself in Dockerfile?

 * Your Dockerfile can be smaller.
 * It reduces the time needed to write a correct Dockerfile. You won't have to worry about the base system and the stack, you can focus on just your app.
 * It sets up the base system **correctly**. It's very easy to get the base system wrong, but this image does everything correctly. [Learn more.](https://github.com/phusion/baseimage-docker#contents)
 * It drastically reduces the time needed to run `docker build`, allowing you to iterate your Dockerfile more quickly.
 * It reduces download time during redeploys. Docker only needs to download the base image once: during the first deploy. On every subsequent deploys, only the changes you make on top of the base image are downloaded.

<a name="about"></a>
## About the image

<a name="whats_included"></a>
### What's included?

*Passenger-standalone-docker is built on top of a solid base: [baseimage-docker](http://phusion.github.io/baseimage-docker/).*

Basics (learn more at [baseimage-docker](http://phusion.github.io/baseimage-docker/)):

 * Ubuntu 14.04 LTS as base system.
 * A **correct** init process ([learn more](http://phusion.github.io/baseimage-docker/)).
 * Fixes APT incompatibilities with Docker.

Language support:

 * Ruby 1.9.3, 2.0.0 and 2.1.0.
   * 2.1.0 is configured as the default.
   * Ruby is installed through [the Brightbox APT repository](https://launchpad.net/~brightbox/+archive/ruby-ng). We're not using RVM!
 * Python 2.7 and Python 3.0.
 * Node.js 0.10, through [Chris Lea's Node.js PPA](https://launchpad.net/~chris-lea/+archive/node.js/).
 * A build system, git, and development headers for many popular libraries, so that the most popular Ruby, Python and Node.js native extensions can be compiled without problems.

Web server and application server:

 * Nginx 1.6. Disabled by default.
 * [Phusion Passenger 4](https://www.phusionpassenger.com/). Disabled by default (because it starts along with Nginx).
   * This is a fast and lightweight tool for simplifying web application integration into Nginx.
   * It adds many production-grade features, such as process monitoring, administration and status inspection.
   * It replaces (G)Unicorn, Thin, Puma, uWSGI.
   * Node.js users: [watch this 4 minute intro video](http://vimeo.com/phusionnl/review/84945384/73fe7432ee) to learn why it's cool and useful.

<a name="memory_efficiency"></a>
### Memory efficiency

Passenger-standalone-docker is very lightweight on memory. In its default configuration, it only uses less than 10 MB of memory.

<a name="image_variants"></a>
### Image variants

Passenger-docker consists of several images, each one tailor made for a specific user group.

**Ruby images**

 * `phusion/passenger-standalone-ruby19` - Ruby 1.9.
 * `phusion/passenger-standalone-ruby20` - Ruby 2.0.
 * `phusion/passenger-standalone-ruby21` - Ruby 2.1.

**Node.js and Meteor images**

 * `phusion/passenger-standalone-nodejs` - Node.js 0.11.

<a name="getting_started"></a>
### Getting started

There are several images, e.g. `phusion/passenger-standalone-ruby21` and `phusion/passenger-standalone-nodejs`. Choose the one you want. See [Image variants](#image_variants).

So put the following in your Dockerfile:

    # Use phusion/passenger-standalone-ruby21 as base image. To make your builds reproducible, make
    # sure you lock down to a specific version, not to `latest`!
    # See https://github.com/phusion/passenger-standalone-docker/blob/master/Changelog.md for
    # a list of version numbers.
    FROM phusion/passenger-standalone-ruby21:<VERSION>
    # Or, instead of the 'full' variant, use one of these:
    #FROM phusion/passenger-standalone-ruby19:<VERSION>
    #FROM phusion/passenger-standalone-ruby20:<VERSION>
    #FROM phusion/passenger-standalone-ruby21:<VERSION>
    #FROM phusion/passenger-standalone-nodejs:<VERSION>
 
    # Include your app
    ADD git@github.com:your-name/your-app /app
    
    # Set any environment variables
    ENV RAILS_ENV production
    
    # .. etc ..

<a name="app_user"></a>
### The `app` user

The image has an `app` user with UID 9999 and home directory `/app`. Your application is supposed to run as this user. Even though Docker itself provides some isolation from the host OS, running applications without root privileges is good security practice.

Your application should be placed inside /app.

<a name="selecting_default_ruby"></a>
### Selecting a default Ruby version

The default Ruby (what the `/usr/bin/ruby` command executes) is the latest Ruby version that you've chosen to install. You can use `ruby-switch` to select a different version as default.

    # Ruby 1.9.3 (you can ignore the "1.9.1" suffix)
    RUN ruby-switch --set 1.9.1
    # Ruby 2.0.0
    RUN ruby-switch --set 2.0
    # Ruby 2.1.0
    RUN ruby-switch --set 2.1

<a name="administering"></a>
## Administering the image's system

<a name="inspecting_web_app_status"></a>
### Inspecting the status of your web app

If you use Passenger to deploy your web app, run:

    passenger-status
    passenger-memory-stats

<a name="logs"></a>
### Logs

If anything goes wrong, consult the log files in /var/log. The following log files are especially important:

 * /var/log/nginx/error.log
 * /var/log/syslog
 * Your app's log file in /app.

<a name="building"></a>
## Building the image yourself

If for whatever reason you want to build the image yourself instead of downloading it from the Docker registry, follow these instructions.

Clone this repository:

    git clone https://github.com/phusion/passenger-standalone-docker.git
    cd passenger-standalone-docker

Start a virtual machine with Docker in it. You can use the Vagrantfile that we've already provided.

    vagrant up
    vagrant ssh
    cd /vagrant

Build one of the images:

    make build_ruby19
    make build_ruby20
    make build_ruby21
    make build_nodejs

If you want to call the resulting image something else, pass the NAME variable, like this:

    make build NAME=joe/passenger

<a name="conclusion"></a>
## Conclusion

 * Using passenger-standalone-docker? [Tweet about us](https://twitter.com/share) or [follow us on Twitter](https://twitter.com/phusion_nl).
 * Having problems? Please post a message at [the discussion forum](https://groups.google.com/d/forum/passenger-docker).
 * Looking for a minimal image containing only a correct base system? Take a look at [baseimage-docker](https://github.com/phusion/baseimage-docker).

[<img src="http://www.phusion.nl/assets/logo.png">](http://www.phusion.nl/)

Please enjoy passenger-standalone-docker, a product by [Phusion](http://www.phusion.nl/). :-)
