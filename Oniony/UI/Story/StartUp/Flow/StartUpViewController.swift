//
//  StartUpViewController.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import UIKit

protocol StartUpViewInput: AnyObject {}

final class StartUpViewController: UIViewController, StartUpViewInput {
    
    var viewOutput: StartUpViewOutput!
}
