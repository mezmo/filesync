from setuptools import setup, find_packages
from sys import path

from filesync import __version__

NAME = "filesync"
if __name__ == "__main__":

    with open('requirements.txt') as f:
        REQS = f.read().splitlines()

    setup(
        name=NAME,
        version=__version__,
        author="RelEng",
        author_email="rel-eng@logdna.com",
        url="https://github.com/mezmo/filesync",
        license='ASLv2',
        packages=find_packages(),
        package_dir={NAME: NAME},
        description="sync templated common files across repos",
        install_requires=REQS,
        entry_points={
            'console_scripts': ['filesync = filesync.cli:main'],
        }
    )
