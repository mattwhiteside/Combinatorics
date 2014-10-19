// Playground - noun: a place where people can play

import Foundation















public protocol Summable : Equatable {
	func +(lhs: Self, rhs: Self) -> Self
    
}

public protocol Multiplicable : Equatable {
  func *(lhs: Self, rhs: Self) -> Self
}

public protocol Invertible : Equatable{
	func invert() -> Self
}

extension Int64 : Multiplicable { }

extension Int64 : Invertible {

	public func invert() -> Int64{
		return -self
	}

}

extension Double : Invertible{
	public func invert() -> Double{
		return 1.0/self
	}
}

//extension UInt64 : Numeric{
//  func multiply(right: Multiplicable) -> Multiplicable{
//		return 5
//	}
//}


//
//public class SymmetryGroup<T where T:Hashable, T:Multiplicable, T:Invertible> : Set<T>{
//	let I:T
//	let groupOperation:(x: T, y: T) -> T
//	let inversionOperation:(x:T) -> T
//	
//	public init(identityElement:T, groupOperation: (x: T, y: T) -> T, inversionOperation: (x:T) -> T){
//		I = identityElement
//		self.groupOperation = groupOperation
//		self.inversionOperation = inversionOperation
//		super.init()
//	}
//	
//}



func checkTransitivity<T:Equatable>(A:Set<T>) -> Bool{
	for item in A{
		
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


infix operator **{associativity left precedence 200 }
public func **(var base:Int, var exp:Int) -> Int{
	var result:Int = 1;
	while (exp != 0)
	{
		if (exp & 1) == 1{
			result *= base;
		}
		exp >>= 1;
		base *= base;
	}
	
	return result;
}

//operator infix ** { }
//
func ** (base: Double, power: Double) -> Double {
	return exp(log(base) * power)
}










//func choose(n: UInt, k: UInt, busWidth: UInt) -> UInt{
//	var ret: UInt = 1
//	for i in stride(from: n, to: n - k , by: -1){
//		ret *= i
//		ret /= ((n - i) % busWidth) + 1
//	}
//	return ret
//}

//func choose(n: UInt, k: UInt, busWidth: UInt) -> UInt{
//	var ret: UInt = 1
//	for i in stride(from: n, to: n - k , by: -1){
//		ret *= i
//		ret /= ((n - i) % busWidth) + 1
//	}
//	return ret
//}

public func choose(n: UInt, k: UInt, busWidth: UInt) -> UInt{
	let objectCounts:[UInt] = [UInt](count:Int(n), repeatedValue: 1)
	return choose(objectCounts, k, busWidth)
}

func chooseOld(objectCounts:[UInt], k: UInt, busWidth: UInt) -> UInt{
	var ret: UInt = 1
	let n:UInt = objectCounts.reduce(0, +)
	let start = n - k + 1
	let shift = start % busWidth//denominator needs to start at 1
	for i in start...n{
		ret *= i
		ret /= ((i + shift) % busWidth) + 1
	}

	return ret
	
}

public func choose(objectCounts:[UInt], k: UInt, busWidth: UInt) -> UInt{
	var ret: UInt = 1
	let n:UInt = objectCounts.reduce(0, +)
	for i in stride(from: n, to: n - k , by: -1){
		ret *= i
		ret /= ((n - i) % busWidth) + 1
	}
	for i in objectCounts{
		ret /= factorial(i)
	}
	return ret
}

public func factorial(n:UInt) -> UInt{
	return choose(n,n,1)
}

postfix operator ^-- {}
public postfix func ^--(n:UInt) -> UInt{
	return choose(n,n,1)
}


infix operator ^- {}
public func ^-(n: UInt, k: UInt) -> UInt {
	return choose(n,k,1)
}


func permutations(n:UInt, k: UInt) -> UInt{
	return choose(n, k, 1)
}

public func enumerateFunctions(n:Int) -> Void{
	for row in 0..<(2**(2**n)){
		println("\(row.toBinStr(2**n))")
	}
}

public func checkAssociativity<T:Hashable>(set:Array<T>, f:(T, T) -> T) -> Bool{
	
	
	for row in 0 ..< (set.count ** 3){
		let left = set[Int(row / (set.count**2)) % (set.count ** 2)]
		let middle = set[Int(row / set.count) % set.count]
		let right = set[row % set.count]
		if f(left,f(middle,right)) != f(f(left,middle),right){
			return false
		}
		
	}
	
	return true
}

//this will be slow
public func checkAllAssociativities<T:Hashable>(set:Array<Character>) -> Void{


	let numRows = set.count ** 2

	var inputCombos = [String]()
	for row in 0 ..< numRows{
		//let left = set[Int(argRow / (set.count**2)) % (set.count ** 2)]
		let left = set[Int(row / set.count) % set.count]
		let right = set[row % set.count]

		
	}
	
	for col in 0 ..< (set.count ** numRows){
		
		for inputCombo in inputCombos{
			let arg1 = inputCombos[0]
			let arg2 = inputCombos[1]
			
		}
		for outputRow in 0 ..< numRows{
			
		}
		
		let f = {(x:Character,y:Character) -> Character in
			return "a"
		}
		checkAssociativity(set, f)
	}


	//let x = S.order();
}

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
	public func toBinStr(_ targetLength:Int = 1) -> String{
		var ret = ""
		var counter = self
		while counter > 0{
			let digit = counter % 2
			ret = "\(digit)\(ret)"
			counter /= 2
		}
		let currentLen = countElements(ret)
		let diff = targetLength - currentLen
		for i in 0..<diff{
			ret = "0\(ret)"
		}
		return ret
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
	
}


typealias variable = (Double -> Double)

	