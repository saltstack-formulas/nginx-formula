=====
nginx
=====

Install nginx either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

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
