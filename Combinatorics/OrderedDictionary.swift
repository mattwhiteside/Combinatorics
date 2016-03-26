//
//  OrderedDictionary.swift
//  Combinatorics
//
//  Created by Matthew Whiteside on 1/30/15.
//  Copyright (c) 2015 mattwhiteside. All rights reserved.
//

import Foundation

public struct OrderedDictionary<Tk: Hashable, Tv> : Sequence {
	var keys: Array<Tk>
	var values: Dictionary<Tk,Tv>
  
	public init(){
		keys = Array<Tk>()
		values = Dictionary<Tk,Tv>()
	}
	
	public subscript(key: Tk) -> Tv? {
		get {
			return self.values[key]
		}
		set(newValue) {
			
		}
	}
  
  public func makeIterator() -> OrderedDictionaryIterator<Tk,Tv> {
    return OrderedDictionaryIterator(self)
  }
	
	
  
}


public class OrderedDictionaryIterator<Tk:Hashable, Tv> : IteratorProtocol{
	var current:Int = 0
	let dict:OrderedDictionary<Tk,Tv>
	init(_ dict:OrderedDictionary<Tk,Tv>){
		self.dict = dict
	}
	
	public func next() -> (Tk, Tv)?{
		if current < dict.keys.count{
			let key = dict.keys[current]
			return (key, dict[key]!)
		} else{
			return nil
		}
	}
}