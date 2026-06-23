# gRPC

## example.proto
```
syntax = "proto3";

package package.subpackage;

option optimize_for = LITE_RUNTIME;

service ServiceName {
    // 1
    rpc ConsiderCoverageEndDate (ConsiderCoverageEndDateParams) returns (ConsiderCoverageEndDateResult) {}
    // 2
    rpc GetConsiderCoverageEndDates (ConsiderCoverageEndDatesParams) returns (ConsiderCoverageEndDatesResult) {}
    // 3 (used, can be combined with GetConsiderCoverageEndDatesResult in client)
    rpc GetConsiderCoverageEndDates (GetConsiderCoverageEndDatesParams) returns (GetConsiderCoverageEndDatesResult) {}
    // 4
    rpc GetConsiderCoverageEndDatesResult (ConsiderCoverageEndDatesParams) returns (ConsiderCoverageEndDatesResult) {}
}

message Coverage {
	string id = 1;
}

message Coverages {
	repeated Coverage coverages = 1;
}

message GetConsiderCoverageEndDatesParams {
	Coverages coverages = 1;
	string inputData = 2;
}

message CoverageEndDateConsiderationResult {
	Coverage coverage = 1;
	bool considerEndDate = 2;
}

message GetConsiderCoverageEndDatesResult {
	repeated CoverageEndDateConsiderationResult result = 1;
}
```
