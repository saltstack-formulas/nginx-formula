
Changelog
=========

`2.3.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v2.2.1...v2.3.0>`_ (2019-09-01)
-------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** replace EOL pre-salted images (\ `70e1426 <https://github.com/saltstack-formulas/nginx-formula/commit/70e1426>`_\ )

Features
^^^^^^^^


* **passenger:** inc config, snippets, servers, etc (\ `e07b558 <https://github.com/saltstack-formulas/nginx-formula/commit/e07b558>`_\ )

`2.2.1 <https://github.com/saltstack-formulas/nginx-formula/compare/v2.2.0...v2.2.1>`_ (2019-08-25)
-------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **readme:** update testing section (\ `182f216 <https://github.com/saltstack-formulas/nginx-formula/commit/182f216>`_\ )

`2.2.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v2.1.0...v2.2.0>`_ (2019-08-12)
-------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **yamllint:** include for this repo and apply rules throughout (\ `6b7d1fe <https://github.com/saltstack-formulas/nginx-formula/commit/6b7d1fe>`_\ )

`2.1.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v2.0.0...v2.1.0>`_ (2019-08-04)
-------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** modify matrix to include ``develop`` platform (\ `f6b357d <https://github.com/saltstack-formulas/nginx-formula/commit/f6b357d>`_\ )

Features
^^^^^^^^


* **linux:** archlinux support (no osfinger grain) (\ `ab6148c <https://github.com/saltstack-formulas/nginx-formula/commit/ab6148c>`_\ )

`2.0.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.1.0...v2.0.0>`_ (2019-06-19)
-------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **snippets:** removed appending of ".conf" (\ `aa87721 <https://github.com/saltstack-formulas/nginx-formula/commit/aa87721>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **snippets:** Users have to modify their pillar
  according to this commit. Users MUST append '.conf' for their
  existing managed snippets.

`1.1.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.5...v1.1.0>`_ (2019-06-03)
-------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **tofs:** first implemetation + tplroot (\ `d5262ea <https://github.com/saltstack-formulas/nginx-formula/commit/d5262ea>`_\ )

`1.0.5 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.4...v1.0.5>`_ (2019-05-13)
-------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **readme:** improve readme sections (\ `3cc3407 <https://github.com/saltstack-formulas/nginx-formula/commit/3cc3407>`_\ )

`1.0.4 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.3...v1.0.4>`_ (2019-05-13)
-------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* prevent running of states deprecated in ``v1.0.0`` (\ `46dff15 <https://github.com/saltstack-formulas/nginx-formula/commit/46dff15>`_\ )

`1.0.3 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.2...v1.0.3>`_ (2019-05-13)
-------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **readme:** add warning banner about ``v1.0.0`` breaking changes (\ `d553821 <https://github.com/saltstack-formulas/nginx-formula/commit/d553821>`_\ )

`1.0.2 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.1...v1.0.2>`_ (2019-05-12)
-------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **readme:** update README, add badges (\ `adbac43 <https://github.com/saltstack-formulas/nginx-formula/commit/adbac43>`_\ )

`1.0.1 <https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.0...v1.0.1>`_ (2019-05-12)
-------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* remove obsolete CHANGELOG.rst file (\ `698aadb <https://github.com/saltstack-formulas/nginx-formula/commit/698aadb>`_\ )

`1.0.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v0.56.1...v1.0.0>`_ (2019-05-12)
--------------------------------------------------------------------------------------------------------

Build System
^^^^^^^^^^^^


* remove obsolete Makefile (\ `4961b04 <https://github.com/saltstack-formulas/nginx-formula/commit/4961b04>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* replace old ``nginx`` with ``nginx.ng`` (\ `0fc5070 <https://github.com/saltstack-formulas/nginx-formula/commit/0fc5070>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* all previous ``nginx`` based configurations must be reviewed;
  ``nginx.ng`` usage must be promoted to ``nginx`` and any uses of the original
  ``nginx`` will have to be converted.

`0.56.1 <https://github.com/saltstack-formulas/nginx-formula/compare/v0.56.0...v0.56.1>`_ (2019-04-27)
----------------------------------------------------------------------------------------------------------

Tests
^^^^^


* **inspec:** add test for ``log_format`` `#219 <https://github.com/saltstack-formulas/nginx-formula/issues/219>`_ (\ `4ed788e <https://github.com/saltstack-formulas/nginx-formula/commit/4ed788e>`_\ )

`0.56.0 <https://github.com/saltstack-formulas/nginx-formula/compare/v0.55.1...v0.56.0>`_ (2019-04-26)
----------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **\ ``pillar.example``\ :** add stock ``log_format`` (\ `95ff308 <https://github.com/saltstack-formulas/nginx-formula/commit/95ff308>`_\ )

`0.55.1 <https://github.com/saltstack-formulas/nginx-formula/compare/v0.55.0...v0.55.1>`_ (2019-04-26)
----------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **semantic-release:** implement an automated changelog (\ `569b07a <https://github.com/saltstack-formulas/nginx-formula/commit/569b07a>`_\ )
