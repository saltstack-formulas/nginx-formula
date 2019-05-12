.. _readme:

nginx-formula
=============

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/nginx-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/nginx-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Formula to set up and configure nginx

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see :ref:`How to contribute <CONTRIBUTING>` for more details.

Available states
================

.. contents::
    :local:

``nginx``
---------

Meta-state for inclusion of all states.

**Note:** nginx requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``nginx.pkg``
-------------

Installs nginx from package, from the distribution repositories, the official nginx repo or the ppa from Launchpad.

``nginx.src``
-------------

Builds and installs nginx from source.

``nginx.certificates``
----------------------

Manages the deployment of nginx certificates.

``nginx.config``
----------------

Manages the nginx main server configuration file.

``nginx.service``
-----------------

Manages the startup and running state of the nginx service.

``nginx.servers_config``
------------------------

Manages virtual host files. This state only manages the content of the files
and does not bind them to service calls.

``nginx.servers``
-----------------

Manages nginx virtual hosts files and binds them to service calls.

``nginx.passenger``
-------------------

Installs and configures Phusion Passenger module for nginx. You need to enable
the upstream phusion passenger repository with `install_from_phusionpassenger: true`.
Nginx will also be installed from that repository, as it needs to be modified to
allow the passenger module to work.
