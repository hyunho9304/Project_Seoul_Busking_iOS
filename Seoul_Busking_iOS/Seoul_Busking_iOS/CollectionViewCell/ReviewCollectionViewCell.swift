//
//  ReviewCollectionViewCell.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 12..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var reviewStar1: UIImageView!
    @IBOutlet weak var reviewStar2: UIImageView!
    @IBOutlet weak var reviewStar3: UIImageView!
    @IBOutlet weak var reviewStar4: UIImageView!
    @IBOutlet weak var reviewStar5: UIImageView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewNicknameLabel: UILabel!
    @IBOutlet weak var reviewProfileImageView: UIImageView!
}
