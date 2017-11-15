//
//  WindVC.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 14.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import UIKit

class WindVC: UIViewController {

    // wind degree property assigned here
    var degree = 0
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rotate arrow to wind direction degree
        arrowImage.image = arrowImage.image?.rotated(by: Measurement(value: Double(degree), unit: .degrees))
        
        // lock to portrait orientation
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
