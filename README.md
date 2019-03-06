# Sketching Algorithms
A collection of sketching algorithms in Swift.

* [x] [BitSet](#bitset)
* [x] [MinHash](#minhash)
* [x] [HyperLogLog](#hyperloglog)
* [x] [Bloom filter](#bloom-filter)
* [ ] Count-min

# Overview

## Installation

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

