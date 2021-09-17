//
//  UIViewController.swift
//  Marvel
//
//  Created by shuynh on 9/16/21.
//

import UIKit

extension UIViewController {

    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        spinner.hidesWhenStopped = true
        spinner.style = .medium
        spinner.startAnimating();

        alert.view.addSubview(spinner)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoading() {
        dismiss(animated: true, completion: nil)
    }

}
