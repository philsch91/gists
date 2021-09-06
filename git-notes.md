# Git Documentation and Snippets

## Git diff
```
// check for merge conflict markers
git diff --check
// set exit code (1 = diff true, 0 = diff false)
// writes also to stdout
git diff --exit-code
```

## Merge local and remote Git branches with unrelated histories
1. `git switch -c <branch-name>`
2. `git pull <remote-name> <remote-branch-name> --allow-unrelated-histories`
3. `git push <remote-name> HEAD:<temp-remote-branch-name>`
4. `create pull request in order to merge <remote-name>/<temp-remote-branch-name> into <remote-name>/<remote-branch-name>`
5. `git push -d <remote-name> <temp-remote-branch-name>`
6. `git pull <remote-name> <remote-branch-name>`

## Fetch and search for a remote branch
1. `git fetch --all`
2. `git branch -a | grep -Ei release*`

## Set remote settings in config
- `git config remote.origin.url https://github.com/abc/abc.git`
- `git config remote.upstream.url https://github.com/abc/abc.git`
- `git config branch.master.remote origin`

## Patch files - resolve merge conflicts partially
1. `git switch master`
1. `git checkout -p <branch-name> <file-name>`

## Resolve merge conflicts
1. `git fetch --all`
1. `git switch dev`
1. `git merge master`
1. `git switch master`
1. `git merge dev --no-ff`
1. `git push`

## Git stash
1. `git stash (= git stash push)`
1. `git stash list`
1. `git stash apply stash@{<index>}`
1. `git stash drop stash@{<index>}`

## Clean working copy
1. `git clean -nd`
1. `git clean -fd`
