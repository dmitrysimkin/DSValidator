//
//  ViewController.swift
//  DSValidatorExample
//
//  Created by Dzmitry Simkin on 5/17/20.
//  Copyright © 2020 Dzmitry Simkin. All rights reserved.
//

import UIKit
import DSValidator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let errors = DSValidator.validate(value: "Test", rule: makeRule().notEmpty().required().length(from: 5, to: 8))
        print(errors)
    }
}

