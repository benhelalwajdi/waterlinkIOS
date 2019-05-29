//
//  FactureTableViewController.swift
//  waterlink
//
//

import UIKit
import Alamofire
import SwiftyJSON

class FactureTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    var factureArray : NSArray = []
    var id : String?
    var data : JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factureCell", for: indexPath)
        let facture = factureArray[indexPath.row] as! Dictionary<String,Any>
        let content = cell.viewWithTag(0)
        let periodLabel = content?.viewWithTag(1) as! UILabel
        let statusLabel = content?.viewWithTag(2) as! UILabel
        let statusImageView = content?.viewWithTag(3) as! UIImageView
        
        
        let firstPeriod = facture["date_debut"] as! String
        let endPeriod = facture["date_fin"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let firstDateObj = dateFormatter.date(from: firstPeriod)
        let finalDateObj = dateFormatter.date(from: endPeriod)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let finalFirstPeriod = dateFormatter.string(from: firstDateObj!)
        let finalPeriod = dateFormatter.string(from: finalDateObj!)

        periodLabel.text = "Du " + finalFirstPeriod + " Au " + finalPeriod
        let status = facture["status"] as? Int
        if(status == 0){
            statusLabel.text = "non payée"
            statusImageView.image = UIImage(named: "cancel")
            statusImageView.setImageColor(color: .red)
        } else if (status == 1) {
            statusLabel.text = "payée"
            statusImageView.image = UIImage(named: "approval")
            statusImageView.setImageColor(color: .green)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: indexPath)
    }
    
    func getData(){
        Alamofire.request(Common.Global.LOCAL + "/get_facture/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
            response in
            self.factureArray = response.result.value as! NSArray
            self.data = JSON(response.result.value)
            print(self.factureArray)
            self.tableView.reloadData()
        }
    }
    
   
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? NSIndexPath
        let factureID = self.data![index!.row]["id"].stringValue
        print(factureID)
       // print("id facture = " + factureID!)
        
        if segue.identifier == "toDetails" {
            
            
            if let destinationVC =  segue.destination as? DetailFactureTableViewController {
                destinationVC.idFacture = factureID
            }
            
        }
    }
    
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
