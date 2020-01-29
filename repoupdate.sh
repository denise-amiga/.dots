# repoupdate [--sub] --repo dexed --author basile-z --branch master --name dexed-2

set -e

m_branch="master"
m_sub="N"

usage(){
	echo "usage: ./repoupdate [--sub] --repo reponame --author repoauthor [--branch master] [--name namealternative]"
	exit 1
}

[[ $# < 2 ]] && usage

# parse command line arguments
while [[ $# -gt 0 ]]
do
	arg="$1"
	case $arg in
		--sub|-s)
			m_sub="Y"
			shift
			;;
		--repo|-r)
			shift
			m_repo="$1"
			shift
			;;
		--author|-a)
			shift
			m_author="$1"
			shift
			;;
		--branch|-b)
			shift
			m_branch="$1"
			shift
			;;
		--name|-n)
			shift
			m_name="$1"
			shift
			;;
		--help|-h)
			m_help="Y"
			shift
			;;
		*)
			shift
			;;
	esac
done

[[ "$m_help" = "Y" ]] && usage

if [[ "$m_name" = "" ]]; then
	m_name="$m_repo"
fi

if [[ ! -d /d/_misrepos ]]; then
	mkdir /d/_misrepos
fi

cd /d/_misrepos

if [[ ! -d "$m_name" ]]; then
	git clone --recursive git@github.com:denise-amiga/"$m_name".git
	cd "$m_name"
	git remote add upstream https://github.com/"$m_author"/"$m_repo".git
	cd ..
fi

cd "$m_name"
git submodule update --recursive --remote

if [[ "$m_sub" = "Y" ]]; then
	git add .
	git commit -m "Updated Submodules."
else
	git fetch upstream
	git checkout "$m_branch"
	git merge upstream/"$m_branch"
fi
git push
