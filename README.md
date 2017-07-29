Gentoo OpenNebula overlay
=========================

The purpose of this repository is to provide the necessary packaging files for
installing the OpenNebula Enterprise Cloud software on a Gentoo Linux-based
host.

Status
------

As of this time, the work contained herein is highly experimental and not at
all supported by myself or OpenNebula upstream.  While some things may work,
the code is known to be broken on `musl`-based Gentoo systems and quite
possibly won't work in your environment.

If it breaks, you get to keep the pieces.

Usage
-----

Clone the repository somewhere convenient, then add the cloned directory to
your `PORTDIR_OVERLAY` path.  You should then be able to run
`emerge -a app-emulation/opennebula` to install OpenNebula on your system.
