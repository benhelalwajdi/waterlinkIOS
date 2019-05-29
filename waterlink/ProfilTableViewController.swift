//
//  ProfilTableViewController.swift
//  waterlink
//
//

import UIKit
import SwiftyJSON
import Alamofire

class ProfilTableViewController: UITableViewController {
    
    
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var prenomLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var codePostalLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 5
        } else if (section == 1){
            return 3
        } else if (section == 2){
            return 1
        }
        return 0
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDefaults.standard.setValue("notSigned", forKey: "signStatus")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func getData(){
        Alamofire.request(Common.Global.LOCAL + "/user/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
            response in
            let jsonResponse = JSON(response.result.value!)
            print(jsonResponse)
            let region = jsonResponse[0]["region"].stringValue
            let nom = jsonResponse[0]["nom"].stringValue
            let prenom = jsonResponse[0]["prenom"].stringValue
            let codePostal = jsonResponse[0]["code_postal"].stringValue
            let mail = jsonResponse[0]["email"].stringValue
            let numTel = jsonResponse[0]["num_tel"].stringValue
            let dateInscription = jsonResponse[0]["date_inscrit"].stringValue
            let adresse = jsonResponse[0]["adresse"].stringValue
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            self.regionLabel.text = region
            self.nomLabel.text = nom
            self.prenomLabel.text = prenom
            self.telLabel.text = numTel
            self.mailLabel.text = mail
            self.codePostalLabel.text = codePostal
            self.regionLabel.text = region
            self.dateLabel.text = self.getDate(dateString: dateInscription)
            self.adresseLabel.text = adresse
            
            
        }
        
    }
    func getDate(dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let newFormat = DateFormatter()
        newFormat.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return newFormat.string(from: date)
        } else {
            return nil
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//extension JSON {
//
//    public var date: Date? {
//        get {
//            switch self.type {
//            case .string:
//                return Formatter.jsonDateFormatter.date(from: self.object as! String)
//            default:
//                return nil
//            }
//        }
//    }
//
//    public var dateTime: Date? {
//        get {
//            switch self.type {
//            case .string:
//                return Formatter.jsonDateTimeFormatter.date(from: self.object as! String)
//            default:
//                return nil
//            }
//        }
//    }
//
//}
//class Formatter {
//    static let jsonDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
//
//    static let jsonDateTimeFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
//        return formatter
//    }()
//}
