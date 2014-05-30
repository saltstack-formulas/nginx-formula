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
---------

Runs the states to install nginx, configure the common files, and the users.

``nginx.common``
----------------

Ensures standard nginx files are in place, and configures enabled sites.

``nginx.luajit2``
-----------------

Installs luajit.

``nginx.openresty``
-------------------

Installs openresty.

``nginx.package``
-----------------

Installs the nginx package via package manager.

``nginx.source``
----------------

Installs nginx via the source files.

``nginx.users``
---------------

Installs apache utils, and configures nginx users specified in the pillar.

Next-generation, alternate approach
===================================

The following states provide an alternate approach to managing Nginx and Nginx
vhosts, as well as code organization. Please provide feedback by filing issues,
discussing in ``#salt`` in Freenode and the mailing list as normal.

.. contents::
    :local:

``nginx.ng``
------------

Meta-state for inclusion of all ng states.

**Note:** nginx.ng requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``nginx.ng.install``
--------------------

Installs the nginx package.

``nginx.ng.config``
-------------------

Manages the nginx main server configuration file.

``nginx.ng.service``
--------------------

Manages the startup and running state of the nginx service.

``nginx.ng.vhosts_config``
--------------------------

Manages virtual host files. This state only manages the content of the files
and does not bind them to service calls.

``nginx.ng.vhosts``
-------------------

Manages nginx virtual hosts files and binds them to service calls.
