//
//  StringExtensions.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/11.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func convertToDict() -> [String: Any]? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let dictionary = jsonObject as? [String: Any] else {
                return nil
            }
            
            return dictionary
        } catch {
            print("Error deserializing JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
