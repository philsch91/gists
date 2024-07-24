# Git

Documentation, Notes and Snippets for Git

## config
```
git config --global --list
git config --global --add user.name $user
git config --global --add user.email $email
git config --global --add credential.helper "store --file $HOME/.git-credentials"
git config --global --add http.https://github.com.proxy http://<proxy-host>:<proxy-port>
git config --global --add filter.lfs.clean "git-lfs clean -- %f"
git config --global --add filter.lfs.smudge "git-lfs smudge -- %f"
git config --global --add filter.lfs.process "git-lfs filter-process"
git config --global --add filter.lfs.required true
git config --global core.symlinks true

git config --global pull.rebase true
git config --global alias.allog "log --all --decorate --oneline --graph"
git config --global alias.lga "log --all --decorate --pretty=oneline --graph"

// Set core.autocrlf to false to not change the line endings at all
git config --global core.autocrlf false
// Set core.autocrlf to input to convert CRLF to LF on commit but not on checkout
git config --global core.autocrlf input
// Set core.autocrlf to true to ensure line endings in files on checkout are converted from LF to CRLF for Windows
// For compatibility, line endings are converted to LF (Unix) style on commit
git config --global core.autocrlf true

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
# rebase commits in (from) `release` on (to) `master`
# assuming `release` is our current branch (git branch)

# rebase preferring our (master) branch changes for merge conflicts
git rebase -Xours master # ours: master, theirs (current): release

# rebase preferring their current (release) branch changes for merge conflicts
git rebase -Xtheirs master # ours: master, theirs (current): release
```

## Git stash
1. `git stash (= git stash push)`
1. `git stash list`
1. `git stash apply stash@{<index>}`
1. `git stash drop stash@{<index>}`

## worktree
```
git worktree add <path (../<new-branch-name>)>
git worktree add <path (../<dir-name>)> <branch>
```

## Clean working copy

`-n` = dry run<br />
`-d` = remove untracked directories in addition to untracked files<br />
`-f` = force<br />

1. `git clean -nd`
1. `git clean -fd`

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
