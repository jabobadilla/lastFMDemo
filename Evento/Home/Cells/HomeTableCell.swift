//
//  AlbumCell.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_artist: UILabel!
    @IBOutlet weak var iv_cover: UIImageView!
    
    @IBOutlet weak var contenedor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contenedor.layer.cornerRadius = 10
        self.contenedor.clipsToBounds = true
    }
}
