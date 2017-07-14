colorize() {
  local words color style
  words=$1
  if [ "$CLICOLOR" = "1" ]; then
    echo -n $words;
    return 1
  fi

  color=$2
  if [[ -z "$color" ]]; then
    color=0
  fi

  style=$3
  if [[ -z "$style" ]]; then
    style=0
  fi

  echo -ne "\[\e[${style};${color}m\]${words}\[\e[0m\]"
}

bold() {
  colorize "$1" "$2" 1
}

git_branch_distance() {
  local dist direction count
  dist=$(git status | head -n2 | tail -n1 | sed -E "s/# Your branch is | of '.*' by| commits.//g")
  direction=$(echo $dist | sed -E "s/[^a-z]+//")
  count=$(echo $dist | sed -E "s/[^0-9]+//")

  if [[ "$direction" -eq "ahead" ]]; then
    printf " + $count"
  elif [[ "$direction" -eq "behind" ]]; then
    printf " - $count"
  fi
}

__git_ps1x() {
  local basedir branch status counter
  basedir=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$basedir" ]; then
    # no git return at once
    return
  fi

  # grab the head
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  # check whether it is clean
  status=$(git status -s --porcelain 2>/dev/null)

  echo -n '['
  if [ -z "$branch" ]; then
    # merge or rebase?
    if [[ -d $basedir/.git/rebase-merge ]]; then
      # indicate we're rebasing
      branch=$(cat $basedir/.git/rebase-merge/head-name | cut -c 12-)
      bold "REBASE" 31
      bold " of "
      bold "$branch" 36
    fi
  else
    if [ -z "$status" ]; then
      # clean directory, print branch green
      bold $branch 32
    else
      # unclean ... is there a special state?
      # indicated by a pipe in the branch name
      if [ -z $(echo $branch | grep '|') ]; then
        # nope, just print yellow
        bold $branch 33
      else
        # yepp, print red
        bold $branch 31
      fi
    fi
  fi

  #git_branch_distance

  # print staged files count in green
  counter=$(echo "$status" | grep -e '^\w.' | wc -l | sed 's/ //g')
  if [ "$counter" -ne "0" ]; then
    echo -n "|" ; bold $counter 32
  fi

  # print unstaged files count in red
  counter=$(echo "$status" | grep -e '^.\w' | wc -l | sed 's/ //g')
  if [ "$counter" -ne "0" ]; then
    echo -n "|" ; bold $counter 31
  fi

  # print untracked files count in purple
  counter=$(echo "$status" | grep -e '^??' | wc -l | sed 's/ //g')
  if [ "$counter" -ne "0" ]; then
    echo -n "|" ; bold $counter 35
  fi

  echo -n ']'
}

# update ps directly without function
#PS1="$(bold "\u" 32)@\h$(__git_ps1x):$(colorize "\w" 36)> "

# PATH DEFINITION
update_ps1() {
  export PS1="$(bold "\u" 32)@\h$(__git_ps1x):$(colorize "\w" 36)> "
}

function renameTerminal() {
    guake -r "$SOMENAME";
  }
export PROMPT_COMMAND='update_ps1;'
