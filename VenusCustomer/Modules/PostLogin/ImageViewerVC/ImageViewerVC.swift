//
//  ImageViewerVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 30/11/24.
//

import UIKit
import SDWebImage

class ImageViewerVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgView.sd_setImage(with: URL(string: url) , placeholderImage: nil, options: [.refreshCached, .highPriority], completed: nil)
    }
    
    @IBAction func btnImageAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
