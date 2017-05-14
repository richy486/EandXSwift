//
//  RxObserver.swift
//  EandXSwift
//
//  Created by Richard Adem on 14/5/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import RxSwift
import RxCocoa
import ReSwift


class RxObserver<T>: StoreSubscriber {
    
    var state: Variable<T?> = Variable(nil)
    private var store: MainStore
    
    init(store: MainStore) {
        self.store = store
        self.store.subscribe(self)
    }
    
    deinit {
        self.store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        self.state.value = state as? T
    }
}
