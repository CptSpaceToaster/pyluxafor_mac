#!/usr/bin/env python3.7

# System
import os
import setuptools

# Local
from pyluxafor_mac import __project__, __version__, CLI, DESCRIPTION

if os.path.exists('README.rst'):
    README = open('README.rst').read()
else:
    README = ''  # a placeholder, readme is generated on release

if os.path.exists('CHANGES.rst'):
    CHANGES = open('CHANGES.rst').read()
else:
    CHANGES = ''  # a placeholder, changelog is generated on release

setuptools.setup(
    name=__project__,
    version=__version__,

    description=DESCRIPTION,
    url='https://github.com/CptSpaceToaster/pyluxafor_mac',
    author='CptSpaceToaster',
    author_email='cptspacetoaster@gmail.com',

    packages=setuptools.find_packages(),

    entry_points={
        'console_scripts': [CLI + ' = pyluxafor_mac.pyluxafor_mac:main']
    },

    long_description=(README + '\n' + CHANGES),
    license='WTFPL',
    classifiers=[
        'Environment :: Console',
        'Intended Audience :: Other Audience',
        'License :: Freely Distributable',
        'Natural Language :: English',
        'Operating System :: MacOS :: MacOS X',
        'Programming Language :: Python :: 3.7',
    ],

    install_requires=[
        'hidapi >= 0.7.99',
    ],
)