pyluxafor_mac
=============

.. image:: https://img.shields.io/pypi/v/pyluxafor_mac.svg
    :target: https://pypi.python.org/pypi/pyluxafor_mac

A Python3 api and cli for the LuxaforFlag for mac

Installing pyluxafor_mac
========================

Install from pip::

    pip3 install pyluxafor_mac

Usage
=====

Use as an API::

    >>> from pyluxafor_mac import LuxaforFlag
    >>> flag = LuxaforFlag()
    >>> flag.fade(85, 205, 252)

Use as a CLI::

    $ pyluxafor_mac -h
    $ pyluxafor_mac 247 168 184

Contribution
============

For development, clone from github and build everything locally with::

    git clone https://github.com/CptSpaceToaster/pyluxafor_mac.git
    cd pyluxafor_mac
    make dist

Interact with the API from the virtual environment::

    $ venv/bin/python3 # Or actvate this python if you do that sort of thing
    Python 3.7.3 (default, Mar 27 2019, 09:23:15)
    [Clang 10.0.1 (clang-1001.0.46.3)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import pyluxafor_mac
    >>> flag = LuxaforFlag()
    >>> flag.fade(85, 205, 252)

Run the CLI locally from the virtual environment::

    $ venv/bin/pyluxafor_mac -h
    $ venv/bin/pyluxafor_mac 247 168 184

Install the a development version of `pyluxafor_mac` into your globally-installed packages::

    $ make install

If installing from source, you will need to take an extra step and install the runtime dependencies globally as well::

    $ pip3 install hidapi