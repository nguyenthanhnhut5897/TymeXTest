//
//  UIImageViewExtensions.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 18/8/24.
//

import SDWebImage

extension UIImageView {
    func loadImage(_ urlStr: String?, placeholderImage placeholder: UIImage? = UIImage(systemName: "person.fill") ) {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            self.sd_setImage(with: url, placeholderImage: placeholder, completed: { (img, error, cacheType, url) in
                DispatchQueue.main.async { [weak self] in
                    self?.image = img != nil ? img : placeholder
                }
            })
        } else {
            self.image = placeholder
        }
    }
}
