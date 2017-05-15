//
//  ViewModel.swift
//  EandXSwift
//
//  Created by Richard Adem on 14/5/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//
//  https://medium.cobeisfresh.com/implementing-mvvm-in-ios-with-rxswift-458a2d47c33d
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    private struct Constants {
        static let URLPrefix = "http://api.openweathermap.org/data/2.5/weather?q="
    }
    
    let disposeBag = DisposeBag()
    
    var searchText = BehaviorSubject<String?>(value: "")

    
    var cityName = BehaviorSubject<String>(value: "")
    var degrees = BehaviorSubject<String>(value: "")
    
    var weather:Weather? {
        didSet {
            if let name = weather?.name {
                DispatchQueue.main.async() {
                    self.cityName.onNext(name)
                }
            }
            if let temp = weather?.degrees {
                DispatchQueue.main.async() {
                    self.degrees.onNext("\(temp)°K")
                }
            }
        }
    }
    
    func getURLForString(_ string: String) -> URL? {
        
        guard let plistPath = Bundle.main.path(forResource: "Keys", ofType: "plist", inDirectory: "Secrets") else {
            return nil
        }
        
        guard let keys = NSDictionary(contentsOfFile: plistPath) else {
            return nil
        }
        
        guard let key = keys["weather"] as? String else {
            return nil
        }
        
        
        let urlString = "\(Constants.URLPrefix)\(string)&appid=\(key)"
        return URL(string: urlString)
    }
    
    
    
    init() {
        
        /*
        let jsonRequest = searchText
            .map { text in
                return URLSession.shared.rx.json(url: self.getURLForString(text!)!)
            }
            .switchLatest()
        // switchLatest() makes sure jsonRequest only returns the most recent sequence
        
        jsonRequest.subscribe(onNext: { json in
            self.weather = Weather(json: json as AnyObject)
        })
        .addDisposableTo(disposeBag)
        */

        /*
        let searchTextObservable : Observable<String?> = self.searchText
        searchTextObservable
            .map { text in
                
                return URLSession.shared.rx.json(url: self.getURLForString(text!)!)
            }
            .subscribe(onNext: { (json) in
                print("json: \(json)")
                self.weather = Weather(json: json as AnyObject)
            })
            .addDisposableTo(disposeBag)
         */
        
        let searchTextObservable : Observable<String?> = self.searchText
        searchTextObservable
        .filter { query in
            guard let query = query else {
                return false
            }
            return query.characters.count > 2
        }
        .debounce(0.5, scheduler: MainScheduler.instance)
        .map { query in
            let apiUrl = self.getURLForString((query?.replacingOccurrences(of: " ", with: "%20"))!)!
            return URLRequest(url: apiUrl)
        }
        .flatMapLatest { request in
            return URLSession.shared.rx.json(request: request)
                .catchErrorJustReturn([])
        }
        .map { json ->  [String: Any] in
            guard let json = json as? [String: Any] else {
                    return ["json error": "on no!"]
            }
            return json
        }
        .subscribe(onNext: { (json) in
            print("json: \(json)")
            self.weather = Weather(json: json)
        })
        .addDisposableTo(disposeBag)
    }
}
