//
//  ProfilViewController.swift
//  waterlink
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfilViewController: UIViewController {

    @IBOutlet weak var adressetxt: UILabel!
    @IBOutlet weak var codepostaltxt: UILabel!
    @IBOutlet weak var locationtxt: UILabel!
    @IBOutlet weak var emaailtxt: UILabel!
    @IBOutlet weak var phonetxt: UILabel!
    @IBOutlet weak var websitetxt: UILabel!
    @IBOutlet weak var regiontxt: UILabel!
    @IBOutlet weak var Nomtxt: UILabel!
    override func viewDidLoad() {
        getData()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func getData(){
        Alamofire.request(Common.Global.LOCAL + "/user/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
            response in
            let jsonResponse = JSON(response.result.value)
            print(jsonResponse)
            let region = jsonResponse[0]["region"].stringValue
            let nom = jsonResponse[0]["nom"].stringValue
            let prenom = jsonResponse[0]["prenom"].stringValue
            let codepostal = jsonResponse[0]["code_postal"].intValue
            let mail = jsonResponse[0]["mail"].stringValue
            let numtel = jsonResponse[0]["num_tel"].intValue

            
            self.regiontxt.text = region
            self.Nomtxt.text = nom + prenom
            self.phonetxt.text = String(numtel)
            self.emaailtxt.text = mail
            self.codepostaltxt.text = String(codepostal)
            self.locationtxt.text = region
            self.adressetxt.text = region

        }
        
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
