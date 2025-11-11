#!/bin/sh
# Update RELEASE versions, delete and re-create CURRENT versions

handle_sigint() {
    echo "Caught SIGINT (Ctrl-C), exiting."
    exit 1
}
trap handle_sigint INT

extract_version() {
    local jail="$1"
    local base_jail suffix version major minor release
    # Remove architecture suffix (text after the first hyphen)
    base_jail="${jail%%-*}"
    
    case "$base_jail" in
        *cur)
            suffix="CURRENT"
            version="${base_jail%cur}"
            ;;
        *rel)
            suffix="RELEASE"
            version="${base_jail%rel}"
            ;;
        *sta)
            suffix="STABLE"
            version="${base_jail%sta}"
            ;;
        *)
            echo "Unrecognized jail naming: $jail" >&2
            return 1
            ;;
    esac

    # Extract major (all but the last digit) and minor (last digit)
    major="${version%?}"
    minor="${version##$major}"
    release="${major}.${minor}-${suffix}"
    echo "$release"
}

jail_list="$(poudriere jail -l)"
JAILS="$(cat jails)"

for jail in $JAILS
do
    echo
    echo ===== Updating jail $jail
    sudo poudriere jail -k -j "$jail"
    
    release="$(extract_version "$jail")"
    if [ $? -ne 0 ]; then
        echo "Skipping jail $jail due to naming issue."
        continue
    fi
    arch="${jail##*-}"
    arch="$(echo "$arch" | sed 's/_/./g')"
    echo '*****' $arch

    if echo "$jail" | grep -q cur; then
        # CURRENT jail: if it exists, delete it, then re-create.
        if echo $jail_list | grep -qw "$jail"; then
            sudo poudriere jail -d -j "$jail" -y
        fi
        sudo poudriere jail -c -a $arch -j "$jail" -v "$release"
    else
        # RELEASE jail: create if it doesn't exist, else update.
        if ! echo $jail_list | grep -qw "$jail"; then
	    echo === Creating jail $jail release $release
            sudo poudriere jail -c -a $arch -j "$jail" -v "$release"
        else
            sudo poudriere jail -u -j "$jail"
        fi
    fi
done

