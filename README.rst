pyluxafor_mac
=============

.. image:: https://img.shields.io/pypi/v/pyluxafor_mac.svg
    :target: https://pypi.python.org/pypi/pyluxafor_mac

A Python3 api and cli for the LuxaforFlag for mac

Installing pyluxafor_mac
========================

Install from pip::

    pip3 install pyluxafor_mac

Use as an API::

    >>> from pyluxafor_mac import LuxaforFlag
    >>> flag = LuxaforFlag()
    >>> flag.fade(85, 205, 252)

Use as a CLI::

    $ pyluxafor_mac 247 168 184

For development, clone from github and run the tests with::

    git clone https://github.com/CptSpaceToaster/pyluxafor_mac.git
    cd pyluxafor_mac
    make test

Usage
=====

Help::

    pyluxafor_mac -h
