//
//  ViewController.swift
//  EandXSwift
//
//  Created by Richard Adem on 14/5/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let throttleInterval = 0.1
    
    let button:UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("press", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50).isActive = true
        
        storeObserver.state.asObservable().map{ $0?.counter }
            .subscribe(onNext: { state in
                
                if let counter = state {
                    print("view controller: \(counter)")
                }
            })
            .addDisposableTo(disposeBag)
//        
        button.rx
            .tap
            .throttle(throttleInterval, scheduler: MainScheduler.instance) // Since you want to keep everything on the main thread, use MainScheduler.
            .subscribe { (event) in
                print("event: \(event)")
                store.dispatch(CounterActionIncrease())
            }.addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

