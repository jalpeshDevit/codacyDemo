//
//  JPLoader.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import Foundation

import UIKit

/// Loader Class
class JPLoader {
    
    //MARK: - Variable
    static let shared = JPLoader()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    //MARK: - Init
    private init() {
        configureActivityIndicator()
    }

    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    //MARK: - Function
    func startLoading() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                
                self.activityIndicator.center = keyWindow.center
                keyWindow.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                
                keyWindow.isUserInteractionEnabled = false
            }
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                // Enable user interaction after stopping the loading
                keyWindow.isUserInteractionEnabled = true
            }
        }
    }
}
