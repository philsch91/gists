# Git

Documentation, Notes and Snippets for Git

## config
```
git config --global --add user.name $user
git config --global --add user.email $email
git config --global --add credential.helper "store --file $HOME/.git-credentials"
git config --global --add http.https://github.com.proxy http://<proxy-host>:<proxy-port>
git config --global --add filter.lfs.clean "git-lfs clean -- %f"
git config --global --add filter.lfs.smudge "git-lfs smudge -- %f"
git config --global --add filter.lfs.process "git-lfs filter-process"
git config --global --add filter.lfs.required true

echo "https://${github_name}:${github_pat}@github.com" >>${HOME}/.git-credentials
```

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

## Change last commit message
```
// the last commit must not have been pushed
git commit --amend -m "new commit message"
```
