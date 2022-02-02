.. _readme_apt_keyrings:

apt repositories' keyrings
==========================

Debian family of OSes deprecated the use of `apt-key` to manage repositories' keys
in favor of using `keyring files` which contain a binary OpenPGP format of the key
(also known as "GPG key public ring")

As nginx and passenger don't provide such key files, we created them following the
official recomendations in their sites and install the resulting files.

Ngninx
------

See https://nginx.org/en/linux_packages.html#Debian for details

.. code-block:: bash

   $ curl -s https://nginx.org/keys/nginx_signing.key | \
       gpg --dearmor --output nginx-archive-keyring.gpg

Phusion-passenger
-----------------

See https://www.phusionpassenger.com/docs/tutorials/deploy_to_production/installations/oss/ownserver/ruby/nginx/
for more details.

.. code-block:: bash

   $ gpg --keyserver keyserver.ubuntu.com \
         --output - \
         --recv-keys 561F9B9CAC40B2F7 | \
     gpg --export --output phusionpassenger-archive-keyring.gpg
