// The MIT License (MIT)
//
// Copyright (c) 2014 Nate Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public struct Set<T: Hashable> : Equatable {
	typealias Element = T
	private var contents: [Element: Bool]
	
	public init() {
		self.contents = [Element: Bool]()
	}
 
	public init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
		self.contents = [Element: Bool]()
		Swift.map(sequence) { self.contents[$0] = true }
	}
 
	/// The number of elements in the Set.
	public var count: Int { return contents.count }
	
	/// Returns `true` if the Set is empty.
	public var isEmpty: Bool { return contents.isEmpty }
	
	/// The elements of the Set as an array.
	public var elements: [Element] { return Array(self.contents.keys) }
 
	/// Returns `true` if the Set contains `element`.
	public func contains(element: Element) -> Bool {
		return contents[element] ?? false
	}
	
	/// Add `newElements` to the Set.
	public mutating func add(newElements: Element...) {
		newElements.map { self.contents[$0] = true }
	}
	
	/// Remove `element` from the Set.
	public mutating func remove(element: Element) -> Element? {
		return contents.removeValueForKey(element) != nil ? element : nil
	}
	
	/// Removes all elements from the Set.
	public mutating func removeAll() {
		contents = [Element: Bool]()
	}
 
	/// Returns a new Set including only those elements `x` where `includeElement(x)` is true.
	public func filter(includeElement: (T) -> Bool) -> Set<T> {
		return Set(self.contents.keys.filter(includeElement))
	}
 
	/// Returns a new Set where each element `x` is transformed by `transform(x)`.
	public func map<U>(transform: (T) -> U) -> Set<U> {
		return Set<U>(self.contents.keys.map(transform))
	}
 
	/// Returns a single value by iteratively combining each element of the Set.
	public func reduce<U>(var initial: U, combine: (U, T) -> U) -> U {
		return Swift.reduce(self, initial, combine)
	}
}

// MARK: SequenceType

extension Set : SequenceType {
	typealias Generator = MapSequenceGenerator<DictionaryGenerator<T, Bool>, T>
	
	/// Creates a generator for the items of the set.
	public func generate() -> Generator {
		return contents.keys.generate()
	}
}

// MARK: ArrayLiteralConvertible

extension Set : ArrayLiteralConvertible {
//	public static func convertFromArrayLiteral(arrayLiteral: T...) -> Set<T> {
//		return Set(arrayLiteral)
//	}
	public init(arrayLiteral elements: Element...){
		self.init()
		for e in elements{
			self.contents[e] = true
		}
	}
}

// MARK: Set Operations

extension Set {
	/// Returns `true` if the Set has the exact same members as `set`.
	public func isEqualToSet(set: Set<T>) -> Bool {
		return self.contents == set.contents
	}
	
	/// Returns `true` if the Set shares any members with `set`.
	public func intersectsWithSet(set: Set<T>) -> Bool {
		for elem in self {
			if set.contains(elem) {
				return true
			}
		}
		return false
	}
 
	/// Returns `true` if all members of the Set are part of `set`.
	public func isSubsetOfSet(set: Set<T>) -> Bool {
		for elem in self {
			if !set.contains(elem) {
				return false
			}
		}
		return true
	}
 
	/// Returns `true` if all members of `set` are part of the Set.
	public func isSupersetOfSet(set: Set<T>) -> Bool {
		return set.isSubsetOfSet(self)
	}
 
	/// Modifies the Set to add all members of `set`.
	public mutating func unionSet(set: Set<T>) {
		for elem in set {
			self.add(elem)
		}
	}
 
	/// Modifies the Set to remove any members also in `set`.
	public mutating func subtractSet(set: Set<T>) {
		for elem in set {
			self.remove(elem)
		}
	}
	
	/// Modifies the Set to include only members that are also in `set`.
	public mutating func intersectSet(set: Set<T>) {
		self = self.filter { set.contains($0) }
	}
	
	/// Returns a new Set that contains all the elements of both this set and the set passed in.
	public func setByUnionWithSet(var set: Set<T>) -> Set<T> {
		set.extend(self)
		return set
	}
 
	/// Returns a new Set that contains only the elements in both this set and the set passed in.
	public func setByIntersectionWithSet(var set: Set<T>) -> Set<T> {
		set.intersectSet(self)
		return set
	}
 
	/// Returns a new Set that contains only the elements in this set *not* also in the set passed in.
	public func setBySubtractingSet(set: Set<T>) -> Set<T> {
		var newSet = self
		newSet.subtractSet(set)
		return newSet
	}
}

// MARK: ExtensibleCollectionType

extension Set : ExtensibleCollectionType {
	typealias Index = Int
	public var startIndex: Int { return 0 }
	public var endIndex: Int { return self.count }
 
	public subscript(i: Int) -> Element {
		return Array(self.contents.keys)[i]
	}
 
	public mutating func reserveCapacity(n: Int) {
		// can't really do anything with this
	}
	
	/// Adds newElement to the Set.
	public mutating func append(newElement: Element) {
		self.add(newElement)
	}
	
	/// Extends the Set by adding all the elements of `seq`.
	public mutating func extend<S : SequenceType where S.Generator.Element == Element>(seq: S) {
		Swift.map(seq) { self.contents[$0] = true }
	}
}

// MARK: Printable

extension Set : Printable, DebugPrintable {
	public var description: String {
		return "Set(\(self.elements))"
	}
 
	public var debugDescription: String {
		return description
	}
}

// MARK: Operators

public func +=<T>(inout lhs: Set<T>, rhs: T) {
	lhs.add(rhs)
}

public func +=<T>(inout lhs: Set<T>, rhs: Set<T>) {
	lhs.unionSet(rhs)
}

public func +<T>(lhs: Set<T>, rhs: Set<T>) -> Set<T> {
	return lhs.setByUnionWithSet(rhs)
}

public func ==<T>(lhs: Set<T>, rhs: Set<T>) -> Bool {
	return lhs.isEqualToSet(rhs)
}

//public func << <T:Hashable>(S:Set<T>, object: T) -> Bool{
//	if S.contains(object){
//		return false;
//	} else{
//		S.append(object)
//		return true
//	}
//}



// MARK: - Tests

//let vowelSet = Set("aeiou")
//let alphabetSet = Set("abcdefghijklmnopqrstuvwxyz")
//let emptySet = Set<Int>()
//
//assert(vowelSet.isSubsetOfSet(alphabetSet) == true)
//assert(vowelSet.isSupersetOfSet(alphabetSet) == false)
//assert(alphabetSet.isSupersetOfSet(vowelSet) == true)
//assert(emptySet.isEmpty)
//assert(vowelSet.count == 5)
//assert(vowelSet.contains("b") == false)
//
//var mutableVowelSet = vowelSet
//mutableVowelSet.add("a")
//assert(mutableVowelSet.count == 5)
//mutableVowelSet += "y"
//assert(mutableVowelSet.count == 6)
//mutableVowelSet += Set("åáâäàéêèëíîïìøóôöòúûüù")
//
//assert(mutableVowelSet.intersectsWithSet(alphabetSet) == true)
//assert(mutableVowelSet.isSubsetOfSet(alphabetSet) == false)
//var newLetterSet = alphabetSet.setByIntersectionWithSet(mutableVowelSet)
//newLetterSet.remove("y")
//assert(newLetterSet == vowelSet)
//
//let bracketedLetterSet = vowelSet.map { "[\($0)]" }
//assert(bracketedLetterSet.contains("[a]") == true)
//
//
//
//// MARK: - Timing
//
//func timeBlock(block: () -> Int) -> (Int, NSTimeInterval) {
//	let start = NSDate()
//	let result = block()
//	return (result, NSDate().timeIntervalSinceDate(start))
//}
//
//var timedSet = Set<Int>()
//var timedArray = Array<Int>()
//
//let (setCreatedCount, setCreatedTime) = timeBlock {
//	for _ in 1...1_000 {
//		let num = Int(arc4random_uniform(1_000))
//		timedSet.add(num)
//	}
//	return timedSet.count
//}
//println("Set added \(setCreatedCount) unique elements in \(setCreatedTime).")
//
//let (setMatchedCount, setMatchedTime) = timeBlock {
//	var matchCount = 0
//	for _ in 1...1_000 {
//		let num = Int(arc4random_uniform(1_000))
//		if timedSet.contains(num) {
//			++matchCount
//		}
//	}
//	return matchCount
//}
//println("Set matched \(setMatchedCount) elements out of 1000 in \(setMatchedTime).")
//
//let (arrayCreatedCount, arrayCreatedTime) = timeBlock {
//	for _ in 1...1_000 {
//		let num = Int(arc4random_uniform(1_000))
//		timedArray.append(num)
//	}
//	return timedArray.count
//}
//println("Array added \(arrayCreatedCount) elements in \(arrayCreatedTime).")
//
//let (arrayMatchedCount, arrayMatchedTime) = timeBlock {
//	var matchCount = 0
//	for _ in 1...1_000 {
//		let num = Int(arc4random_uniform(1_000))
//		if contains(timedArray, num) {
//			++matchCount
//		}
//	}
//	return matchCount
//}
//println("Array matched \(arrayMatchedCount) elements out of 1000 in \(arrayMatchedTime).")
//
//println()
//println("Array \(Int(setCreatedTime / arrayCreatedTime))x faster at creation than Set.")
//println("Set \(Int(arrayMatchedTime / setMatchedTime))x faster at lookup than Array.")
//
///*
//Set added 637 unique elements in 1.2172309756279.
//Set matched 650 elements out of 1000 in 0.00271201133728027.
//Array added 1000 elements in 0.00527894496917725.
//Array matched 612 elements out of 1000 in 2.09512096643448.
//
//Array 230x faster at creation than Set.
//Set 772x faster at lookup than Array.
//*/