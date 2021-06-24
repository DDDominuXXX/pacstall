#!/bin/bash

apt -qq update
apt -qq -yy install equivs curl git

### Install Dependencies
apt-get -qq --yes update
apt-get -qq --yes dist-upgrade
apt-get -qq --yes install devscripts lintian build-essential automake autotools-dev axel
mk-build-deps -i -t "apt-get --yes" -r

### Update pacstall
echo

mkdir -p \
        bin \
        usr/share/bash-completion/completions \
        usr/share/man/man8/ \
        usr/share/pacstall/scripts

echo

{
	printf "%s %s\n" \
        pacstall            "https://raw.githubusercontent.com/pacstall/pacstall/master/pacstall"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o bin/$name
	done
}

{
	printf "%s %s\n" \
        pacstall            "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/completion/bash"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o usr/share/bash-completion/completions/$name
	done
}

{
	printf "%s %s\n" \
        pacstall.8.gz       "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/pacstall.8.gz"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o usr/share/man/man8/$name
	done
}

{
	printf "%s %s\n" \
        change-repo.sh      "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/scripts/change-repo.sh" \
        search.sh           "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/scripts/search.sh" \
        download.sh         "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/scripts/download.sh" \
        install-local.sh    "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/scripts/install-local.sh" \
        upgrade.sh          "https://raw.githubusercontent.com/pacstall/pacstall/master/misc/scripts/upgrade.sh"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o usr/share/pacstall/scripts/$name
	done
}

chmod +x bin/pacstall
chmod +x usr/share/pacstall/scripts/*

echo "https://raw.githubusercontent.com/pacstall/pacstall-programs/master" > usr/share/pacstall/repo/pacstallrepo.txt

echo

ls -l \
    bin/pacstall \
    usr/share/bash-completion/completions/pacstall \
    usr/share/man/man8/pacstall.8.gz \
    usr/share/pacstall/scripts/{change-repo.sh,search.sh,download.sh,install-local.sh,upgrade.sh}

echo

### Build Deb
mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us