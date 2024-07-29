//
//  Obsearvable.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/23/24.
//

import Foundation

final class Obsearvable<T> {
    private var closure: ((T) -> ())?
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    func bind(_ excuteInit: Bool = false,closure: @escaping (T) -> ()) {
        if excuteInit { closure(value) }
        
        self.closure = closure
    }
}
