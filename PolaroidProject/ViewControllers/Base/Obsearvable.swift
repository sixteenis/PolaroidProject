//
//  Obsearvable.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/9/24.
//

import Foundation

class Obsearvable<T> {
    var closure: ((T) -> ())?
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    func bind(_ excuteInit: Bool = true,closure: @escaping (T) -> ()) {
        if excuteInit { closure(value) }
        
        self.closure = closure
    }
}
