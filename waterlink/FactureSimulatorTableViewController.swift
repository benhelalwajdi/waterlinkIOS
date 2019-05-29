//
//  FactureSimulatorTableViewController.swift
//  waterlink
//
//

import UIKit
import Alamofire
import SwiftyJSON



class FactureSimulatorTableViewController: UITableViewController {
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var totalSonedeLabel: UILabel!
    @IBOutlet weak var totalSonedeTvaLabel: UILabel!
    @IBOutlet weak var totalOnasLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chargesSonede: UILabel!
    @IBOutlet weak var totalEau: UILabel!
    
    var firstPeriod : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.periodLabel.text = getActualDate()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    func getData(){
        Alamofire.request(Common.Global.LOCAL + "/simulerfacture?id_client=" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON { response in
    
            let jsonResponse = JSON(response.result.value)
            print(jsonResponse)
            let totalEau = jsonResponse["totalEau"].stringValue
            let sonedeAvecTva = jsonResponse["SonedeAvecTva"].floatValue / 1000
            let charge = jsonResponse["charge"].floatValue / 1000
            let onas = jsonResponse["onas"].floatValue / 1000
            let totalFacture = jsonResponse["totalFacture"].floatValue / 1000
            let totalSonede = jsonResponse["totalSonede"].floatValue / 1000
            
            self.totalEau.text = totalEau
            self.totalSonedeLabel.text = String(totalSonede)
            self.chargesSonede.text = String(charge)
            self.totalSonedeTvaLabel.text = String(sonedeAvecTva)
            self.totalOnasLabel.text = String(onas)
            self.totalLabel.text = String(totalFacture)
            
        }
    }
    
    func getActualDate() -> String {
        let currentDateTime = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let month = calendar.component(.month, from: currentDateTime)
        let year = calendar.component(.year, from: currentDateTime)
        if(month >= 1 && month <= 3){
            self.firstPeriod = "01/01/" + String(year)
        } else if(month > 3 && month <= 6){
            self.firstPeriod = "01/04/" + String(year)
        } else if(month > 6  && month <= 9){
            self.firstPeriod = "01/07/" + String(year)
        } else if(month > 9  && month <= 12){
            self.firstPeriod = "01/10/" + String(year)
        }
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: currentDateTime)
        
        return "Du " + self.firstPeriod! + " au " + result
    }
}
