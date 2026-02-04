# Git

Documentation, Notes and Snippets for Git

- keep commits clean by separating files and commits, and committing specific files avoiding commits with unrelated changes
- use `git add --patch` instead of `git add --all` if possible
- keep branches short
- squash commits

## variables
```
# $(prefix) = environment variable git was compiled with, usually /usr/local
export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_SYSTEM="$(prefix)/etc/gitconfig"
export GIT_CONFIG_GLOBAL="$HOME/.gitconfig"
```

## files
```
# system config file
$(prefix)/etc/gitconfig # = /usr/local/etc/gitconfig
# global config files
$XDG_CONFIG_HOME/git/config # = $HOME/.config/git/config
~/.gitconfig
# repository config file
$GIT_DIR/config # = .git/config
```

## config
```
git config [--global] -l|--list|list [--show-origin]
git config --global edit (=-e|--edit)
git config --global set <name> <value>
git config --global set --append (=--add) <name> <value>
# config user
git config --global --add user.name $user
git config --global --add user.email $email
# config credential
git config --global --add credential.helper "store --file $HOME/.git-credentials"
# config http
git config --global --add http.https://github.com.proxy http://<proxy-host>:<proxy-port>
# config filter
git config --global --add filter.lfs.clean "git-lfs clean -- %f"
git config --global --add filter.lfs.smudge "git-lfs smudge -- %f"
git config --global --add filter.lfs.process "git-lfs filter-process"
git config --global --add filter.lfs.required true
# config core
git config --global core.symlinks true
git config --global core.filemode false
git config --global core.editor "vim"
git config --global core.excludesfile ~/.gitignore
# config pull
git config --global pull.rebase true
# config push
git config --global push.autoSetupRemote true
# config alias
git config --global alias.allog "log --all --decorate --oneline --graph"
git config --global alias.lag "log --all --decorate --pretty=oneline --graph"
# config core.autocrlf
// Set core.autocrlf to false to not change the line endings at all
git config --global core.autocrlf false
// Set core.autocrlf to input to convert CRLF to LF on commit but not on checkout
git config --global core.autocrlf input
// Set core.autocrlf to true to ensure line endings in files on checkout are converted from LF to CRLF for Windows
// For compatibility, line endings are converted to LF (Unix) style on commit
git config --global core.autocrlf true
# config core.safecrlf
// Set core.safecrlf to true (default) or warn to verify if the conversion is reversible for the current setting of core.autocrlf
// Set core.safecrlf to true (default) to reject irreversible conversations
git config --global core.safecrlf true
// Set core.safecrlf to warn to only print a warning but accept an irreversible conversion
git config --global core.safecrlf warn
// Set core.safecrlf to false to suppress warnings but still auto convert
git config --global core.safecrlf false

echo "https://${github_name}:${github_pat}@github.com" >>${HOME}/.git-credentials
```

### Set remote settings in config
- `git config remote.origin.url https://github.com/abc/abc.git`
- `git config remote.upstream.url https://github.com/abc/abc.git`
- `git config branch.master.remote origin`

## diff
```
// check for merge conflict markers
git diff --check
// set exit code (1 = diff true, 0 = diff false)
// writes also to stdout
git diff --exit-code
```

## remote
```
git remote show origin
# show and get remote HEAD (default) branch
git remote show origin | sed -n '/HEAD branch/s/.*: //p'
```

## push
```
// push local branch <local-branch-name> named as <remote-branch-name> to remote repo
git push origin <local-branch-name>:<remote-branch-name>

// push local branch <local-branch-name> named as <remote-branch-name> to remote repo
// and where a remote tag with the same name exists
git push <remote-name> refs/heads/<remote-branch-name>:refs/heads/<local-branch-name>

// delete remote tag
git push -d <remote-name> <tag-name>
// delete remote tag with tag and branch of the same name
git push -d origin refs/tags/<tag-name>
```

## tag
```
// create annotated tag
git tag -a <tag-name> -m <message>
// list local tags
git tag -l "<tag-name>*"
// push a tag to remote server
git push <remote-name> refs/tags/<tag-name>
// delete tag on remote server
git push -d <remote-name> refs/tags/<tag-name>
// delete local tag
git tag -d <tag-name>
// push all local tags not present on remote server
git push <remote-name> --tags
// fetch <tag-name-1> from remote repo and create reference <tag-name-2> in local repo
git fetch <remote-name> refs/tags/<tag-name-1>:refs/tags/<tag-name-2>
// fetch all tags from remote repo
git fetch [--all] --tags [--prune]
```

## Merge local and remote Git branches with unrelated histories
1. `git switch -c <branch-name>`
2. `git pull <remote-name> <remote-branch-name> --allow-unrelated-histories`
3. `git push <remote-name> HEAD:<temp-remote-branch-name>`
4. `create pull request in order to merge <remote-name>/<temp-remote-branch-name> into <remote-name>/<remote-branch-name>`
5. `git push -d <remote-name> <temp-remote-branch-name>`
6. `git pull <remote-name> <remote-branch-name>`

## fetch

### Fetch and search for a remote branch
1. `git fetch --all`
2. `git branch -a | grep -Ei release*`

### Delete obsolete remote tracking branches
```
git fetch --all --prune
```

## checkout
```
// create and checkout new branch from tag
git checkout -b <branch-tag-name> refs/tags/<tag-name>
// error: The following untracked working tree files would be overwritten by checkout:
// force checkout which will delete local not indexed files
git checkout -f refs/tags/<tag-name>
```

### Patch files - resolve merge conflicts partially
```
// patch from a branch name
git switch <branch>
git checkout -p <branch-name> <file-name>
// patch via a commit-sha
git switch -c <new-branch>
git checkout -p <commit-sha> <file-name>
```

## branch
```
// create new branch from tag
git branch <branch-tag-name> refs/tags/<tag-name>
```

## merge

```
# merge commits in (from) `feature` into (to) `master`
# assuming `master` is our current branch (git branch)

# merge preferring our current (master) branch changes for merge conflicts
git merge -Xours feature # ours (current): master, theirs: feature

# merge preferring their (feature) branch changes for merge conflicts
git merge -Xtheirs feature # ours (current): master, theirs: feature
```

### Resolve merge conflicts
1. `git fetch --all`
1. `git switch dev`
1. `git merge master`
1. `git switch master`
1. `git merge dev --no-ff`
1. `git push`

## rebase
```
# rebase local branch interactively
git rebase -i HEAD~3
# undo interactive rebase of local branch
git reset --soft <remote>/<remote-branch-name>

# rebase commits in (from) `release` on (to) `master`
# assuming `release` is our current branch (git branch)

# rebase preferring our (master) branch changes for merge conflicts
git rebase -Xours master # ours: master, theirs (current): release

# rebase preferring their current (release) branch changes for merge conflicts
git rebase -Xtheirs master # ours: master, theirs (current): release
```

## stash
1. `git stash (= git stash push)`
1. `git stash list`
1. `git stash apply stash@{<index>}`
1. `git stash drop stash@{<index>}`

## worktree
```
git worktree add <path (../<new-branch-name>)>
git worktree add <path (../<dir-name>)> <branch>
```

## reset
```
# undo last commit, --hard = reset committed files to state of former commit, throw away uncommitted changes
git reset --hard HEAD~1
# undo last commit, reset committed files to state of former commit, keep uncommitted changes, reset index
git reset HEAD~1
# undo last commit, --soft = reset committed files to state of former commit, keep uncommitted changes and index
git reset --soft HEAD~1
```

## Clean working copy

`-n` = dry run<br />
`-d` = remove untracked directories in addition to untracked files<br />
`-f` = force<br />

1. `git clean -nd`
1. `git clean -fd`

## Delete empty directories

Git only tracks files and not empty directories.

1. `find . -type d -empty`
2. `ls -lah <directory>`
3. `rm -rv <directory>`

## Change last commit message
```
// the last commit must not have been pushed
git commit --amend -m "new commit message"
```

## gc

error: cannot lock ref 'refs/remotes/<remote-name>/<remote-branch-name>'
```
git gc --prune=now
git reset --hard <remote-name>/<remote-branch-name>
```
