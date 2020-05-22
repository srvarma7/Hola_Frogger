//
//  ARViewController.swift
//  TabView
//
//  Created by Varma on 19/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import QuickLook
import ARKit

class ARViewController: UIViewController, QLPreviewControllerDataSource {
    
    override func viewDidAppear(_ animated: Bool) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let path = Bundle.main.path(forResource: "FROG", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "Frog_Hopping", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "DartFrog", ofType: "obj") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "toy_biplane", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        let url = URL(fileURLWithPath: path)
        return url as QLPreviewItem
    }
}
