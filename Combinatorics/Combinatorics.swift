// Playground - noun: a place where people can play

import Foundation


protocol GenericIntegerType: IntegerType {
	init(_ v: Int)
	init(_ v: UInt)
	init(_ v: Int8)
	init(_ v: UInt8)
	init(_ v: Int16)
	init(_ v: UInt16)
	init(_ v: Int32)
	init(_ v: UInt32)
	init(_ v: Int64)
	init(_ v: UInt64)
}




protocol Group{
	
	typealias T = () -> Self
	
}



//extension Int:Group{
//	typealias T = Int
//	func f() -> Int {
//		return self + 2
//	}
//}






func checkTransitivity<T:Equatable>(A:Set<T>) -> Bool{
	for _ in A{
		
	}	
	return true
}




infix operator ⇒{}
public func ⇒(x:Bool, y:Bool) -> Bool{
	switch (x,y){
	case (false, false):
		return true
		
	case (false, true):
		return false
		
	case (true, false):
		return true
		
	default://(true, true)
		return true
		
	}
}

infix operator **{associativity left precedence 160 }

protocol ℚ {
	init() // zero
	func * (_: Self,_: Self) -> Self
	func + (_: Self,_: Self) -> Self
	func / (_: Self,_: Self) -> Self
	func - (_: Self,_: Self) -> Self
	prefix func + (_: Self) -> Self
	prefix func - (_: Self) -> Self
	func ** (_: Self, _: Self) -> Self
}


public func **(lhs:Float, rhs:Float) -> Float{
	return powf(lhs, rhs)
}

public func **(lhs:Double, rhs:Double) -> Double{
	return pow(lhs, rhs)
}


extension Double : ℚ {}
extension Float : ℚ {}




public func **(base:Int, exp:Int) -> Int{
	var result = 1;
	var _exp = exp
	var _base = base
	while (exp != 0)
	{
		if (exp & 1) == 1{
			result *= _base;
		}
		_exp >>= 1;
		_base *= _base;
	}
	
	return result;
}

// Abstraction of a mathematical vector
protocol VectorType {
	typealias Scalar : ℚ
	//func dotProduct(Self) -> Scalar
	
	// Parts not essential for answering the question
	init()
	var count: Int {get}
	subscript(_: Int) -> Scalar {get set}
	
	func + (_: Self,_: Self) -> Self
	func - (_: Self,_: Self) -> Self
	prefix func + (_: Self) -> Self
	prefix func - (_: Self) -> Self
	func * (_: Self, _: Scalar) -> Self
	func / (_: Self, _: Scalar) -> Self
	func ⋅(_: Self,_: Self) -> Scalar
}


struct EmptyVector<T: ℚ> : VectorType {
	init() {}
	typealias Scalar = T
	
	
	var count: Int { return 0 }
	
	subscript(i: Int) -> Scalar {
		get { fatalError("subscript out-of-range") }
		set { fatalError("subscript out-of-range") }
	}
}


struct Vector<Tail: VectorType> : VectorType {
	typealias Scalar = Tail.Scalar
	
	init(_ scalar: Scalar, tail: Tail = Tail()) {
		self.scalar = scalar
		self.tail = tail
	}
	
	init() {
		self.scalar = Scalar()
		self.tail = Tail()
	}
	
	
	
	var count: Int { return tail.count + 1 }
	var scalar: Scalar
	var tail: Tail
	
	subscript(i: Int) -> Scalar {
		get { return i == 0 ? scalar : tail[i - 1] }
		set { if i == 0 { scalar = newValue } else { tail[i - 1] = newValue } }
	}
}


//===--- A nice operator for composing vectors ----------------------------===//
//===--- there's probably a more appropriate symbol -----------------------===//
infix operator ⋮ {
associativity right
precedence 1 // unsure of the best precedence here
}

infix operator ⋅ { associativity left precedence 120 }

func ⋅<T>(lhs:Vector<T>, rhs:Vector<T>) -> Vector<T>.Scalar{
	return lhs.scalar * rhs.scalar + (lhs.tail ⋅ rhs.tail)
}

func ⋅<T>(lhs:EmptyVector<T>, rhs:EmptyVector<T>) -> EmptyVector<T>.Scalar{
	return EmptyVector<T>.Scalar()
}



func ⋮ <T: ℚ> (lhs: T, rhs: T) -> Vector<Vector<EmptyVector<T> > > {
	return Vector(lhs, tail: Vector(rhs))
}
func ⋮ <T: ℚ, U where U.Scalar == T> (lhs: T, rhs: Vector<U>) -> Vector<Vector<U> > {
	return Vector(lhs, tail: rhs)
}


extension Vector : CustomDebugStringConvertible {
	var debugDescription: String {
		if count == 1 {
			return "Vector(\(String(reflecting: scalar)), tail: EmptyVector())"
		}
		return "\(String(reflecting: scalar)) ⋮ " + (count == 2 ? String(reflecting: self[1]) : String(reflecting: tail))
	}
}


//===--- additive arithmetic ---------------------------------------------===//
func + <T> (_: EmptyVector<T>,_: EmptyVector<T>) -> EmptyVector<T> {
	return EmptyVector()
}
func - <T> (_: EmptyVector<T>,_: EmptyVector<T>) -> EmptyVector<T> {
	return EmptyVector()
}
prefix func + <T> (_: EmptyVector<T>) -> EmptyVector<T> {
	return EmptyVector()
}
prefix func - <T> (_: EmptyVector<T>) -> EmptyVector<T> {
	return EmptyVector()
}



func + <T> (lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
	return Vector(lhs[0] + rhs[0], tail: lhs.tail + rhs.tail)
}
func - <T> (lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
	return Vector(lhs[0] - rhs[0], tail: lhs.tail - rhs.tail)
}
prefix func + <T> (lhs: Vector<T>) -> Vector<T> {
	return lhs
}
prefix func - <T> (lhs: Vector<T>) -> Vector<T> {
	return Vector(-lhs[0], tail: -lhs.tail)
}


//===--- vector-scalar arithmetic -----------------------------------------===//
func * <V: VectorType> (lhs: V.Scalar, rhs: V) -> V {
	return rhs * lhs
}




func * <T> (_: EmptyVector<T>, _: T) -> EmptyVector<T> {
	return EmptyVector()
}


func / <T> (_: EmptyVector<T>, _: T) -> EmptyVector<T> {
	return EmptyVector()
}


func * <T> (lhs: Vector<T>, rhs: T.Scalar) -> Vector<T> {
	return Vector(lhs[0] * rhs, tail: lhs.tail * rhs)
}


func / <T> (lhs: Vector<T>, rhs: T.Scalar) -> Vector<T> {
	return Vector(lhs[0] / rhs, tail: lhs.tail / rhs)
}




//===--- CollectionType conformance ---------------------------------------===//
extension Vector : CollectionType {
	var startIndex: Int { return 0 }
	var endIndex: Int { return count }
}


func chooseOld(objectCounts:[UInt], k: UInt, busWidth: UInt) -> UInt{
	var ret: UInt = 1
	let n:UInt = objectCounts.reduce(0, combine: +)
	let start = n - k + 1
	let shift = start % busWidth//denominator needs to start at 1
	for i in start...n{
		ret *= i
		ret /= ((i + shift) % busWidth) + 1
	}

	return ret
	
}






//public func enumerateFunctions(n:UInt) -> Void{
//	for _ in 0..<(2**(2**n)){
//		//println("\(row.toBinStr(2**n))")
//	}
//}

//public func checkAssociativity<T:Hashable>(set:Array<T>, f:(T, T) -> T) -> Bool{
//	
//	let _count = UInt(set.count)
//	for _ in 0 ..< (_count ** 3){
////		let left = set[Int(row / (_count**2)) % (_count ** 2)]
////		let middle = set[Int(row / _count) % _count]
////		let right = set[row % _count]
////		return f(left,f(middle,right)) != f(f(left,middle),right)		
//	}
//	
//	return true
//}

//this will be slow


extension Bool{
	public func toInt() -> Int{
		if self{
			return 1
		} else{
			return 0
		}
	}
}

extension Int{
	public func toBinStr(targetLength:Int = 1) -> String{
//		var ret = ""
//		var counter = self
//		while counter > 0{
//			let digit = counter % 2
//			ret = "\(digit)\(ret)"
//			counter /= 2
//		}
//		let currentLen = count(ret)
//		let diff = targetLength - currentLen
//		for i in 0..<diff{
//			ret = "0\(ret)"
//		}
//		return ret
		return "implement me"
	}
	
	public func toBitVec(targetLength:Int) -> [Bool]{
		var ret = [Bool]()
		var counter = self
		while counter > 0{
			let digit = counter % 2
			ret.insert(digit == 1, atIndex: 0)
			counter /= 2
		}
		while ret.count < targetLength{
			ret.insert(false, atIndex: 0)
		}
		return ret
	}
	
	
	public func toHex() -> String {
		return NSString(format:"%2X", self) as String
	}
	
	public func choose(k:Int, var busWidth: UInt? = nil) -> Int{
		//let busWidth = k
		var ret: Int = 1
		if let _ = busWidth{
		} else {
			busWidth = UInt(k)
		}
		for i in self.stride(to: self - k , by: -1){
			ret *= i
			ret /= ((self - i) % Int(busWidth!)) + 1
		}
		return ret
	}
}



public func ⋅(x:Bool, y:Bool) -> Bool{
	return x && y
}

prefix operator ¬{}
public prefix func ¬(x:Bool) -> Bool{
	return !x
}

public func +(x:Bool, y:Bool) -> Bool{
	return x || y
}

extension Int{
	
	static let Unity = 1

}





	