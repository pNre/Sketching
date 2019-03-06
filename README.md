# Sketching Algorithms
A collection of sketching algorithms in Swift.

* [x] [BitSet](#bitset)
* [x] [MinHash](#minhash)
* [x] [HyperLogLog](#hyperloglog)
* [ ] Bloom filter
* [ ] Count-min

# Overview

## Installation

### Carthage

Add `Sketching` as a dependency in your project's Cartfile:
```
github "pNre/Sketching"
```

## BitSet

An array-like structure that is optimized to store bits efficiently.

### Usage

```swift
//  create a bit set of 100 bits
var s = BitSet(bitWidth: 100)

//  set bit 0 and 2
s[0] = true
s[2] = true
```

```
(lldb) po s
BitSet (width=100, value=101)
```

```swift
//  bitwise operators
let conjunction = s1 & s2
let disjunction = s1 | s2
let negation = ~s1
```

## MinHash

## HyperLogLog

### Reference
- http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf

### Usage
Have a class/struct conform the `Hashing` protocol by defining an hashing function that produces a 32bit hash.
For example, the test cases use the [fnv1a hash function](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function):

```swift
struct FNV1AHashing: Hashing
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
