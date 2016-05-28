//
//  ProfileFooterView.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

class ProfileFooterView: UIView {

    static let DefaultHeight: CGFloat = 124.0
    
    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var userNameImageView: UILabel!
    
    internal var userName: String! {
        didSet {
            self.userNameImageView.text = self.userName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.height / 2.0
        self.userPhotoImageView.layer.masksToBounds = true
    }

}
