=====
nginx
=====

Install nginx either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``nginx``
------------

Meta-state for inclusion of all states.

**Note:** nginx requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``nginx.pkg``
--------------------

Installs nginx from package, from the distribution repositories, the official nginx repo or the ppa from Launchpad.

``nginx.src``
--------------------

Builds and installs nginx from source.

``nginx.certificates``
-------------------

Manages the deployment of nginx certificates.

``nginx.config``
-------------------

Manages the nginx main server configuration file.

``nginx.service``
--------------------

Manages the startup and running state of the nginx service.

``nginx.servers_config``
--------------------------

Manages virtual host files. This state only manages the content of the files
and does not bind them to service calls.

``nginx.servers``
-------------------

Manages nginx virtual hosts files and binds them to service calls.

``nginx.passenger``
----------------------

Installs and configures Phusion Passenger module for nginx. You need to enable
the upstream phusion passenger repository with `install_from_phusionpassenger: true`.
Nginx will also be installed from that repository, as it needs to be modified to
allow the passenger module to work.

