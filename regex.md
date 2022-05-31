# Regex Notes

## Negative Lookaround

### Negative lookahead
```
// match prod or production but not preprod or preproduction
/^(?!.*pre).*$/i
// match valueabc but not valuexyz
/^(?:(?!xyz).)*$/mg
```

### Negative lookbehind
```
// match prod or production but not preprod or preproduction
/(?<!pre)prod|(?<!pre)production/i
/(?<!PRE)PROD/i
```
