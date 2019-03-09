# Sketching Algorithms
A collection of sketching algorithms in Swift.

* [x] [BitSet](#bitset)
* [x] [MinHash](#minhash)
* [x] [HyperLogLog](#hyperloglog)
* [x] [Bloom Filter](#bloom-filter)
* [x] [Cuckoo Filter](#cuckoo-filter)

# Overview

## Installation

### Swift Package Manager

In `Package.swift` add `Sketching` to the `dependencies`:
```swift
dependencies: [
    .package(url: "https://github.com/pNre/Sketching", .branch("master")),
]
```

Then reference it in the target that uses the package:

```swift
.target(
    name: "CoolExecutable",
    dependencies: ["Sketching"])
```

### Carthage

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

### Usage

Build a `MinHash` and insert some elements in it:

```swift
var a = MinHash<FNV1AHashing>(hashCount: 64)
a.insert("a".utf8)
a.insert("b".utf8)
a.insert("c".utf8)
```

```swift
var b = MinHash<FNV1AHashing>(hashCount: 64)
b.insert("a".utf8)
b.insert("b".utf8)
```

Compare the similarity of two `MinHash` structs:

```
(lldb) po a.jaccard(b)
0.734375
```

Form an union between two `MinHash`:

```swift
let c = a.union(b)
```

```
(lldb) po a.jaccard(c)
1.0
```

## HyperLogLog

### Reference
- http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf

### Usage
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

## Bloom Filter

### Usage

Init a `BloomFilter` with a certain size and number of hash functions:

```swift
var f = BloomFilter<FNV1AHashing>(bitWidth: 128, hashCount: 16)
```

Init a `BloomFilter` with the expected item count and probability of false positives:

```swift
var f = BloomFilter<FNV1AHashing>(expectedCardinality: 10, probabilityOfFalsePositives: 0.001)
```

Insert some elements:
```swift
f.insert("abc".utf8)
f.insert("def".utf8)
```

Test containment:
```
(lldb) po f.contains("gh".utf8)
false
```

## Cuckoo Filter

