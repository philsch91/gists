# Git Documentation and Snippets

## Merge local and remote Git branches with unrelated histories

1. `git switch -c <branch-name>`
2. `git pull <remote-name> <remote-branch-name> --allow-unrelated-histories`
3. `git push <remote-name> HEAD:<temp-remote-branch-name>`
4. `create pull request in order to merge <remote-name>/<temp-remote-branch-name> into <remote-name>/<remote-branch-name>`
5. `git push -d <remote-name> <temp-remote-branch-name>`
6. `git pull <remote-name> <remote-branch-name>`
