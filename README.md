# Sketching Algorithms
A collection of sketching algorithms in Swift.

# Overview

## Installation

WIP

## To-do list
* [x] HyperLogLog
* [ ] Bloom filter
* [ ] Count-min

## HyperLogLog

### Reference
- http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf

### Usage
Have a class/struct conform the `Hashing` protocol by defining an hashing function that produces a 32bit hash.
For example, the test cases use the [fnv1a hash function](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function):

```swift
class FNV1AHashing: Hashing {
    static func hash<C: Collection>(_ val: C) -> UInt32 where C.Element == UInt8 {
        var hash: UInt32 = 2166136261
        for byte in val {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return hash
    }
}
```

With the hashing function just defined:

```swift
var ll = HyperLogLog<FNV1AHashing>()
ll.insert("abc".utf8)
ll.insert("def".utf8)
ll.insert("abc".utf8)
```

```
(lldb) po ll.cardinality()
2.007853430022625
```
