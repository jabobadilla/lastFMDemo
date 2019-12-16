//
//  LeftMenuVC.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    var titles = ["Home",
                  "Agenda",
                  //"Transportación",
                  "Clima",
                  "Vestimenta",
                  "Hotel",
                  //"Recomendaciones",
                  "Restaurantes",
                  //"Galería",
                  "Notificaciones",
                  "SOS"]
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: self.view.frame.size.height-40), style: .plain)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }
    
    // MARK: - <UITableViewDelegate>
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var identifier = ""
        
        switch indexPath.row {
        case 0:
            identifier = "firstViewController"
        case 1:
            identifier = "Agenda"
        /* case 1:
            identifier = "Transportacion" */
        case 2:
            identifier = "Clima"
        case 3:
            identifier = "Vestimenta"
        case 4:
            identifier = "Hotel"
        /* case 5:
            identifier = "Recomendaciones" */
        case 5:
            identifier = "Restaurantes"
        /* case 8:
            identifier = "Galeria" */
        case 6:
            identifier = "Notificaciones"
        case 7:
            identifier = "SOS"
        default:
            identifier = "firstViewController"
        }
        
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: identifier)), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    // MARK: - <UITableViewDataSource>
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = .clear
            cell!.textLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
            cell!.textLabel?.textColor = .white
            cell!.textLabel?.highlightedTextColor = .lightGray
            cell!.selectedBackgroundView = UIView()
        }
        
        
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.imageView?.image = (UIImage(named: titles[indexPath.row]))?.withRenderingMode(.alwaysTemplate)
        cell!.imageView?.tintColor = .white
        
        return cell!
    }
}
