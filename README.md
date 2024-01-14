# Notes on working with FreeBSD ports

These instructions are for me to recall stuff that I regularly look up. They are valid for FreeBSD 14.0.0

## Source
Get the ports source code

    git clone https://github.com/freebsd/freebsd-ports

To checkout the version of a port that is the same version as the distribution:

    git checkout release/14.0.0

Create a new branch to work in

    git branch category/port
where of course category/port is the path of the port in the ports tree.

## Poudriere configuration
To build individial ports in parallel, use

        ALLOW_MAKE_JOBS=yes
in /usr/local/etc/poudriere.conf

Create a jail

        doas poudriere jail -c -j 140rel -v 14.0-RELEASE

Create the ports tree

        doas poudriere ports -c -m null -M /home/laurent/work/freebsd-ports -p default

Update the jail to a new FreeBSD release

        doas poudriere jail -u -j 140rel

## Coding
To make changes in the code, for files that are part of the git repo, make the changes
To make changes in the ported software, first go to its directory and

        make extract
Changes can then be made on any file. Remember to first make a copy with the suffix .orig. That's needed for the patch creation.

## Modify port
If updating the tar file contining the source, after it has been downloaded it needs to be registered with `make makesum`
To make the patches, `make makepatch`
To make the plist, `make makeplist`

To test the changes, if there are dependencies, to install them, do `doas make depends`. Then, to compile and install, just `make`. No root priviledges are required.

Once the changes are all done, the port files can be checked with `portlint`

To test the build including package creation, install and uninstall in a clean environment, use poudriere:

    doas poudriere testport -j 140rel -b release_0 category/port

To test all the ports that I maintain, listed in the file `my_ports`

    doas poudriere bulk -j 140rel -b release_0 -f my_ports

The `-b` option in poudriere makes use of pre-compiled dependencies packages instead of recompiling them all from scratch. It currently requires the `poudriere-devel` version of poudriere.

## Submit changes
When all the changes have all been coded, commit them. The first line of the commit comment must start with `category/port:`
**FreeBSD commiters prefer that all changes are recorded in only one commit**, to reduce the size of the commit log.
If new changes are made, the new commit can be merged to the last one with `git commit --amend`
Once done, a patch can be created for submission

    git format-patch main
Finally, this patch can be submitted to https://bugs.freebsd.org/bugzilla/
