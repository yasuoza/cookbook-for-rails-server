Cookbook for minimum rails server
=================

Server setups
-----------

* zsh
* mysql5.6
* redis
* openssh
* rbenved ruby

Required gems
------------

* chef
* knife-solo
* knife-solo_data_bags

Installation
------------

Clone the repository:

And install gems and chef's necessary packages:

```bash
$ bundle install
$ bundle exec librarian-chef install
```

Finally, you should be able to use:

```bash
$ knife solo prepare vagrant@192.168.11.14
$ knife solo cook vagrant@192.168.11.14 nodes/default.json
$ vagrant up
```

If you want to edit data bags data:

```bash
# to edit
$ knife solo data bag edit users app  

# to preview
$ knife solo data bag show users app  
```

Virtual Machine Management
--------------------------

When done just log out with `^D` and suspend the virtual machine

```bash
$ vagrant suspend
```

then, resume to hack again

```bash
$ vagrant resume
```

Run

```bash
$ vagrant halt
```

to shutdown the virtual machine, and

```bash
$ vagrant up
```

to boot it again.

You can find out the state of a virtual machine anytime by invoking

```bash
$ vagrant status
```

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

```bash
$ vagrant destroy # DANGER: all is gone
```

Information
-----------

* Virtual Machine IP: 192.168.11.14
* User/password: vagrant/vagrant
* MySQL user/password: vagrant/Vagrant
* MySQL root password: nonrandompasswordsaregreattoo
* Ruby versions are 2.0.0-p247(default)
