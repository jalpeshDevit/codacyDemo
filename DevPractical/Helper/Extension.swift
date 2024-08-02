//
//  Extension.swift
//  DevPracticle
//
//  Created by Jalpesh Patel on 05/01/24.
//

import Foundation
import UIKit

//MARK: - STRING
extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func currencyFormater(value: Decimal, currencyCode: String,currencySymbol : String, FractionDigits : Int ) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = currencyCode
            formatter.currencySymbol = currencySymbol
            formatter.maximumFractionDigits = FractionDigits
            return formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
    }
    
    func decodeHtmlEntities() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error decoding HTML entities: \(error)")
            return nil
        }
    }
}

//MARK: - UICollectionView
 extension UICollectionView {
    
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(type, forCellWithReuseIdentifier: identifier ?? cellId)
    }
     
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
}

//MARK: - UICollectionViewCell
 extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK: - UITableView
extension UITableView {
    
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
 
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
}

//MARK: - UITableViewCell
 extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}


//MARK: - UIViewController
extension UIViewController {

    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {

        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showTost(title : String = "" ,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
}
