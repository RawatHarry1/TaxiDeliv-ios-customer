//
//  ViewController.swift
//  E wallet App
//
//  Created by Ayush Verma on 05/11/24.
//

import UIKit
import Foundation

class PackageVC: VCBaseVC {
    
    
    @IBOutlet weak var packageTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        packageTableView.register(UINib.init(nibName: "PackageTableCell", bundle: nil), forCellReuseIdentifier: "PackageTableCell")

    }


}


extension PackageVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = packageTableView.dequeueReusableCell(withIdentifier: "PackageTableCell", for: indexPath) as! PackageTableCell
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 260
    }
    
    
    
}

