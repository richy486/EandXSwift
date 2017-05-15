//
//  RxObserver.swift
//
//  https://medium.com/littlebigsnippets/using-rxswift-with-reswift-in-swift-redux-architecture-d342963c5ffe
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
