# jq

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
