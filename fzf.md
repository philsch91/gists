# fzf

```
profiles=$(grep -oP '(?<=\[profile ).*(?=\])' ~/.aws/config | grep "$filter")'
profile_count=$(echo $profiles | wc -w)
border_height=$(($profile_count + 3))
selected_profile=$(echo $profiles | fzf --reverse --height=$border_height --border --info=inline --prompt="Select an AWS profile: ")
```
