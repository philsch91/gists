# jq

## --arg
```
# $var_name is available with value "<var-value>"
jq --arg <var_name> <var-value> 'has($var_name)' "${FILE_NAME}"
```

## --exit-status (-e)
```
if ! jq -e "https://index.docker.io/v1" "/home/<username>/.docker/config.json" >/dev/null; then
    # exit status was not 0
    # exit status is 0 for non-false and non-null
    # exit status is 1 for false or null
    # exit status is 4 for no valid result
    # normal exit status is 0 for jq execution
    # normal exit status is 2 for usage problem or system error
    # normal exit status is 3 for compile error
fi
```

## identity (.)
```
cat subnets.txt | jq -r . >subnets2.txt
```

## select
```
// .Tags[].Value =~ "private_internal" == select(.Tags[].Value | select(contains("private_internal")))
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c")]'
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone | select(contains("central")))]'
```

## Array construction (AC)

### AC option 1
```
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c" and .Tags[].Key == "Name" and select(.Tags[].Value | select(contains("private_internal"))))]'
```

### AC option 2
```
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c")]' | jq -r '[.[] | select(.Tags[].Key == "Name" and select (.Tags[].Value | select(contains("private_internal"))))]'
```

### AC option 3
```
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c")]' | jq -r '[.[] | select(.Tags[] | select(.Key == "Name" and select(.Value | select(contains("private_internal")))))]'
```

## Object construction (OC)

### OC option 1
```
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c")]' | jq -r '[.[] | select(.Tags[] | select(.Key == "Name" and select(.Value | select(contains("private_internal")))))] | [.[] | {"SubnetName": .Tags[] | select(.Key == "Name") .Value, "SubnetId": .SubnetId}]'
```

### OC Option 2
```
cat subnets.txt | jq -r '[.[] | select(.AvailabilityZone == "eu-central-1c")]' | jq -r '[.[] | select(.Tags[] | select(.Key == "Name" and select(.Value | select(contains("private_internal")))))]' | jq -r '[.[] | {"SubnetName": .Tags[] | select(.Key == "Name") .Value, "SubnetId": .SubnetId}]'
```

## @base64d
```
kubectl -n <namespace> get <resource-type>/<resource-name> -o json | jq -r '.key1.key2 | @base64d'
```
