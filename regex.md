# Regex Notes

## Negative Lookaround
```
// negative lookahead
// match prod or production but not preprod or preproduction
/^(?!.*pre).*$/i
// negative lookbehind
// match prod or production but not preprod or preproduction
/(?<!pre)prod|(?<!pre)production/i
```
