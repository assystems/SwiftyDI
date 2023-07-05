//
//  Injected.swift
//  QiitaExample
//
//  Created by Riku Yamane on 2021/04/15.
//

import Foundation

@propertyWrapper
public struct Injected<Instance> {
    public init(instance: Instance? = nil) {
        self.instance = instance
    }
        
    private var instance: Instance!

    public var wrappedValue: Instance {
        mutating get {
            if instance == nil {
                self.instance = DIContainer.shared.resolve()
            }
            return instance
        }
        mutating set {
            instance = newValue
        }
    }
}
