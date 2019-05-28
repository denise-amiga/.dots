# $1 dexed
# $2 basile-z
# $3 master

if [[ ! -d /d/_misrepos ]]; then
	mkdir /d/_misrepos
fi

cd /d/_misrepos

if [[ ! -d $1 ]]; then
	git clone --recurse-submodules git@github.com:denise-amiga/$1.git
	cd $1
	git remote add upstream https://github.com/$2/$1.git
	cd ..
fi

cd $1
git fetch --recurse-submodules upstream
#git checkout $3
git merge upstream/$3
git push
