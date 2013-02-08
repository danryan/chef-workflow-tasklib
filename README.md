Chef Workflow - Rake Tasks & Support
------------------------------------

This gem provides a set of rake tasks broken up logically to support a chef
workflow, and tooling to assist with driving those tasks. It is intended to
complement a chef repository to keep interaction between multiple consumers of
it fairly uniform.

Some of the tasks it provides are:

* Uploading your cookbooks, roles, environments and databags with the defaults
  expecting a layout similar to the [opscode example
  chef-repo](https://github.com/opscode/chef-repo)
* Resolving your cookbook's dependencies, with tools like
  [librarian](https://github.com/applicationsonline/librarian) or
  [berkshelf](https://github.com/RiotGames/berkshelf) 
* Lint your cookbooks with [foodcritic](https://github.com/acrmp/foodcritic) 
* Creating a chef server for testing in a single command
* Running unit tests against networks of provisioned machines -- see
  [chef-workflow-testlib](https://github.com/chef-workflow/chef-workflow-testlib)
  for more information.
* Create machines on the fly that know about your chef server, work with them
  in a change/converge/inspect cycle, all without having to fire up a ton of
  machines each time or even have to care about where they live or worry about
  forgetting to tear them down. We track that for you.

Most of the Meat is on the Wiki
-------------------------------

This project is a part of
[chef-workflow](https://github.com/chef-workflow/chef-workflow).

Our [wiki](https://github.com/chef-workflow/chef-workflow/wiki) contains
a fair amount of information, including how to try chef-workflow without
actually doing anything more than cloning a repository and running a few
commands.

Contributing
------------

* fork the project
* make a branch
* add your stuff
* push your branch to your repo
* send a pull request

**Note:** modifications to gem metadata, author lists, and other credits
without rationale will be rejected immediately.

Credits
-------

Author: [Erik Hollensbe](https://github.com/erikh)

These companies have assisted by donating time, financial resources, and
employment to those working on chef-workflow. Supporting OSS is really really
cool and we should reciprocate.

* [HotelTonight](http://www.hoteltonight.com) 
