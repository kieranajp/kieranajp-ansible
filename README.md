# My Vagrant & Ansible setup

This creates my super-sexy dev environment in a resusable way, in the form of a Vagrant VM.

The VM runs Ubuntu 14.04 LTS and comes with the following:

- Apache 2.4
- PHP 5.6.6
- MySQL 5.6
- Composer

Credit to Phansible for the initial box that I built upon.

Virtual hosts are set up in a snazzy way:

Creating a folder in the `www` folder "creates" a vhost with the `.vg` (for VaGrant) TLD. The docroot will be `public_html` under that folder.

For example, creating the following folder structure:

`www/kieranajp/public_html/index.php`

Will allow you to visit kieranajp.vg. No config required beyond the initial setup.

This does of course depend on you pointing that domain to the VM's IP address (192.168.33.99).

This is only tested on Mac OS X right now, but I'm pretty sure it'll work on Linux and have plans to get it working on Windows too.

## Instructions

- Make sure you have Vagrant, VirtualBox and Ansible installed
- Clone this down
- Run `vagrant up` and wait for it to provision stuff.
- Either manually edit your `/etc/hosts` or use something like `dnsmasq` to point the `.vg` TLD to 192.168.33.99
    - To do this, `brew install dnsmasq` and follow Homebrew's instructions post-install
    - Add `address=/vg/192.168.33.99` to `/usr/local/etc/dnsmasq.conf`
    - Create `/etc/resolver/vg.conf` containing `nameserver 127.0.0.1`
    - You should now be able to `dig anything.vg` and get a valid response back.
- If you want to be able to `vagrant up` without running sudo, then run `sudo ./vagrant-sudoers.sh` to add `vagrant` to sudoers.


This setup now allows you to create the aforementioned folder structure inside the provided `www` folder and just visit its URL in your browser. Zero config required, you should never have to touch a terminal window.

If you do have an aversion to the terminal entirely, then I recommend [Vagrant Manager](http://vagrantmanager.com/), which will allow you to boot your VM from a GUI. After the initial setup you should never have to touch a terminal window again!

## Troubleshooting

> Something something threadsafe when I try and run the vagrant box for the first time!

SSH into the vagrant box and replace the `mpm_event` symlinks with symlinks to `mpm_prefork` instead - or just `a2dismod mpm_event && a2enmod mpm_prefork` (as root)

> I need node.js and npm installed

The best way is to use [NVM](https://github.com/creationix/nvm)

> I need to change the TLD that's used (from .vg to something else - for example .dev)

On the host, edit `/usr/local/etc/dnsmasq.conf` and add `address=/dev/192.168.33.99`, then create `/etc/resolver/dev.conf` containing `nameserver 127.0.0.1`

On the virtual machine, edit `/etc/apache2/sites-enabled/000-default.conf` and replace all instances of `vg` with `dev` (there should be two). Then restart Apache (with `sudo apachectl restart`).

To change this in the Ansible scripts before you provision the VM, edit `roles/apache/templates/vhost24.conf.tpl` in this repo (note that this canonical version of the repo will remain using `.vg`)

> I don't have CURL / mcrypt / memcached!

`sudo apt-get install php5-curl php5-mcrypt memcached php5-memcached`

> "Killed"

The Vagrant box ran out of RAM! Increase its RAM value in the `VagrantFile`, run `vagrant reload` and try again.
