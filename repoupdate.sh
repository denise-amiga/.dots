# repoupdate [--sub] --repo dexed --author basile-z --branch master --name dexed-2

set -e

# personal settings
_MYREPO_="git@github.com:denise-amiga"
_MYPATH_="$HOME/_misrepos"

# default options
m_branch="master"
m_sub="N"

_DATE_=$(date +%Y%m%d)

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
		--help|-h)
			shift
			m_help="Y"
			;;
		--sub|-s)
			shift
			m_sub="Y"
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
		*)
			shift
			;;
	esac
done

[[ "$m_help" = "Y" ]] && usage

if [[ "$m_name" = "" ]]; then
	m_name="$m_repo"
fi

if [[ ! -d "$_MYPATH_" ]]; then
	mkdir "$_MYPATH_"
fi

cd "$_MYPATH_"

if [[ ! -d "$m_name" ]]; then
	git clone --recursive "$_MYREPO_"/"$m_name".git
	cd "$m_name"
	git remote add upstream https://github.com/"$m_author"/"$m_repo".git
	cd ..
fi

cd "$m_name"
git submodule update --recursive --remote

if [[ "$m_sub" = "Y" ]]; then
	git add .
	git commit -m "Updated Submodules ($_DATE_)."
else
	git fetch upstream
	git checkout "$m_branch"
	git merge upstream/"$m_branch"
fi
git push origin "$m_branch" --tags
