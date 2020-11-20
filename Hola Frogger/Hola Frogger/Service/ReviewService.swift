//
//  ReviewService.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 20/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import StoreKit

class ReviewService {
    
    static let shared = ReviewService()
    
    func requestReview() {
        SKStoreReviewController.requestReview()
    }
    
    func start(vc: UIViewController) {
        AppStorage.appOpenedCount += 1
        let openCount = AppStorage.appOpenedCount
        print("\nApplication opened count - \(openCount)")
        if checkCount(currentCount: openCount) {
            print("Requesting app review")
            showReviewAlert(vc: vc)
        }
    }
    
    func showReviewAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Write a review on App Store?",
                                      message: "Would really appriciate and will be helpful for the developer in creating new content",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yay, Hell ya!!",
                                      style: .default,
                                      handler: { _ in
                                        self.requestReview()
                                      }
        ))
        alert.addAction(UIAlertAction(title: "Nah! Not now",
                                      style: .destructive,
                                      handler: nil))

        vc.present(alert, animated: true)
    }
    
    private func checkCount(currentCount: Int) -> Bool {
        return currentCount == nextReviewCount(currentCount: currentCount) ? true : false
    }
    
    private func nextReviewCount(currentCount: Int) -> Int {
        let initialCount: Int   = 5
        let increaseBy: Int     = 10
        let nextReview = AppStorage.nextReviewCount
        
        switch nextReview {
            case 0:
                                AppStorage.nextReviewCount = initialCount
                                print("Adding initail next review to \(initialCount)")
                                break
            case currentCount:
                                AppStorage.nextReviewCount += increaseBy
                                print("Increasing next review count by \(increaseBy)")
                                break
            default:
                                break
        }
        print("Next review if count is \(AppStorage.nextReviewCount)")
        return nextReview
    }
}
