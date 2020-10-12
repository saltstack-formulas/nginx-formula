# -*- coding: utf-8 -*-
"""
Installation of Openresty modules packaged with OPM
===================================================
A state module to manage openresty modules. Module can be set up to be installed
or removed.
.. code-block:: yaml
    addressable:
      opm.installed
"""
from __future__ import absolute_import, print_function, unicode_literals

from salt.exceptions import CommandExecutionError

import logging
import re

import salt.utils.versions

log = logging.getLogger(__name__)


def __virtual__():
    """
    Only load if opm module is available in __salt__
    """
    if "opm.install" in __salt__:
        return True
    return (False, "opm module could not be loaded")


def installed(name, user=None, version=None, home=None):
    """
    Make sure that a package is installed.
    name
        The name of the package to install

    user: None
        The user under which to run the ``opm`` command

    home: None
        The directory to set as HOME environment variable for the ``opm`` command.

    version: None
        Specify the version to install for the package.
        Doesn't play nice with multiple packages at once.
    """
    ret = {"name": name, "result": None, "comment": "", "changes": {}}

    env = {"HOME": home} if home else {}

    packages = __salt__["opm.list"](runas=user, env=env)

    if name in packages and version is not None:
        match = re.match(r"(>=|>|<|<=)", version)
        if match:
            # Grab the comparison
            cmpr = match.group()

            # Clear out comparison from version and whitespace
            desired_version = re.sub(cmpr, "", version).strip()

            if salt.utils.versions.compare(packages[name], cmpr, desired_version):
                ret["result"] = True
                ret["comment"] = "Installed package meets version requirements."
                return ret
        else:
            if str(version) in packages[name]:
                ret["result"] = True
                ret["comment"] = "Package is already installed."
                return ret
    elif name in packages and version is None:
        ret["result"] = True
        ret["comment"] = "Package is already installed."
        return ret

    if __opts__["test"]:
        ret["comment"] = "The package {0} would have been installed".format(name)
        return ret

    try:
        __salt__["opm.install"](name, runas=user, env=env, version=version)
        ret["result"] = True
        ret["changes"][name] = "Installed"
        ret["comment"] = "Package was successfully installed"
    except CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = "Could not install package: " + e.message

    return ret


def removed(name, user=None, home=None):
    """
    Make sure that package is not installed.

    name
        The name of the package to uninstall

    user: None
        The user under which to run the ``opm`` command

    home: None
        The directory to set as HOME environment variable for the ``opm`` command.
    """
    ret = {"name": name, "result": None, "comment": "", "changes": {}}

    env = {"HOME": home} if home else {}

    if name not in __salt__["opm.list"](runas=user, env=env):
        ret["result"] = True
        ret["comment"] = "Package is not installed."
        return ret

    if __opts__["test"]:
        ret["comment"] = "The package {0} would have been removed".format(name)
        return ret

    if __salt__["opm.remove"](name, runas=user, env=env):
        ret["result"] = True
        ret["changes"][name] = "Removed"
        ret["comment"] = "Package was successfully removed."
    else:
        ret["result"] = False
        ret["comment"] = "Could not remove package."

    return ret
