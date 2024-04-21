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
in `/usr/local/etc/poudriere.conf`

Create jails

        doas poudriere jail -c -j 140rel -v 14.0-RELEASE
        doas poudriere jail -c -j 132rel -v 13.2-RELEASE
        doas poudriere jail -a i386 -c -j 140rel-i386 -v 14.0-RELEASE
        doas poudriere jail -a i386 -c -j 132rel-i386 -v 13.2-RELEASE

Create the ports tree

        doas poudriere ports -c -m null -M /home/laurent/work/freebsd-ports -p default

Update the jail to a new FreeBSD release

        doas poudriere jail -u -j 140rel

## Coding
To make changes in the code, for files that are part of the git repo, make the changes
To make changes in the ported software, first go to its directory and

        make extract
Changes can then be made on any file in `work/portname`. Remember to first make a copy with the suffix .orig. That's needed for the patch creation.

## Modify port
Install dependedncies with `doas make depends clean`. Then, to compile and install, just `make`. No root priviledges are required.

If the source archive need updating, update the `Makefile` with the new version and download the archive with `make fetch`.

Create a new `distinfo` with `make makesum`
`make extract` and then make changes in the `work` tree. Make copies of the modified source files with the suffix `.orig` 

To make the patches, `make makepatch` will create patches using the `.orig` files.

To make `pkg-plist`, `make makeplist` creates a static plist. For a better plist, use `panopticum plist` from `ports-mgmt/hs-panopticum`. It requires poudriere. It will create `pkg-plist` with all the %%OPTIONS%% populated properly. It takes a long time.

To wrap `pkg-descr` to 80 columns, and remove blanks at end of lines (it will keep portlint happy): 

    cat pkg-descr | fold -w 80 -s | sed 's/ $//' > pkg-descr

## Test port
Once the changes are all done, the port files can be checked with `portlint`

To test the build including package creation, install and uninstall in a clean environment, use poudriere:

    doas poudriere testport -j 140rel -b release_0 category/port

To test all the ports that I maintain, listed in the file `my_ports`

    doas poudriere bulk -j 140rel -b release_0 -f my_ports
    doas poudriere bulk -j 132rel -b release_0 -f my_ports
    doas poudriere bulk -j 132rel-i386 -b release_0 -f my_ports
    doas poudriere bulk -j 140rel-i386 -b release_0 -f my_ports

The `-b` option in poudriere makes use of pre-compiled dependencies packages instead of recompiling them all from scratch. It currently requires the `poudriere-devel` version of poudriere.

To find out which other ports use this port, use `portgrep -u <port>` that will find all ports that have `USES=<port>`

## Submit changes
When all the changes have all been coded, commit them. The first line of the commit comment must start with `category/port:`
**FreeBSD commiters prefer that all changes are recorded in only one commit**, to reduce the size of the commit log.
If new changes are made, the new commit can be merged to the last one with `git commit --amend`
Once the changes are commited, a patch can be created for submission

    git format-patch -1 main
This patch can be submitted to https://bugs.freebsd.org/bugzilla/

Finally, restore the git tree by undoing all your changes so that there won't be errors during your next `pull`

    # undo last commit and discard changes
    git reset --hard HEAD~
    # delete untracked files
    git clean -i .

