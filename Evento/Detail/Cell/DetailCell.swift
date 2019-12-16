//
//  RecomendacionesCell.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var lb_trackName: UILabel!
    
    @IBOutlet weak var contenedor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contenedor.layer.cornerRadius = 10
        self.contenedor.clipsToBounds = true
    }
}
