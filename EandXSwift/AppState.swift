//
//  AppState.swift
//  EandXSwift
//
//  Created by Richard Adem on 14/5/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var counter: Int = 0
}


// Actions

struct CounterActionIncrease: Action {}
struct CounterActionDecrease: Action {}


// Reducer

func counterReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case _ as CounterActionIncrease:
        state.counter += 1
    case _ as CounterActionDecrease:
        state.counter -= 1
    default:
        break
    }
    
    return state
}
