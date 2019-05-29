//
//  HomeViewController.swift
//  waterlink
//
//

import UIKit
import ABGaugeViewKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    var value : Float?
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var seuilTextField: UITextField!
    @IBOutlet weak var gaugeView: ABGaugeView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var trancheLabel: UILabel!
    @IBOutlet weak var waterConsumptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.clipsToBounds = true
        refreshButton.layer.cornerRadius = 25.0
        UserDefaults.standard.setValue("signed", forKey: "signStatus")
        getData()
        updatedevicetoken()
        }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        if(seuilTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Erreur", message: "Vous devez entrer une valeur de seuil", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
        Alamofire.request(Common.Global.LOCAL + "/update_seuil?user_id=" + UserDefaults.standard.string(forKey: "idUser")! + "&seuil=" + seuilTextField.text!)
        getData()
    }
    
    func getData(){
        Alamofire.request(Common.Global.LOCAL + "/total/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
            response in
            let result = JSON(response.result.value as Any)
            print("TEST", result)
            if(result["consommation"][0] == JSON.null){
                self.value = 0
                self.valueLabel.text = "0 DT"
                self.waterConsumptionLabel.text = "0 L"
                self.trancheLabel.text = "0 millimes"
                
            } else {
            let tranche = result["consommation"][0]["tranche"].stringValue
            self.trancheLabel.text = tranche  + " millimes"
            let prixTotal = result["consommation"][0]["prix"].stringValue
            let seuil = result["consommation"][0]["seuil"].stringValue
            let totalLitres = result["consommation"][0]["total"].stringValue
            let seuilValue = (seuil as NSString).floatValue
            let litreValue = Float(totalLitres)
            let metreCubeValue = Float(totalLitres)!/1000
            self.value = Float(prixTotal)!/1000
            self.valueLabel.text = String(format: "%.3f", self.value!) + " DT"
            self.waterConsumptionLabel.text = String(format: "%.0f", litreValue!)  + " L | " + String(format: "%.0f", metreCubeValue) + " m3"
            if result["consommation"][0]["seuil"] != JSON.null{
                self.seuilTextField.text = seuil
                self.gaugeView.needleValue = CGFloat((self.value! * 100) / seuilValue)
            }
            if(seuilValue < self.value!){
                self.gaugeView.needleValue = 0
                let alert = UIAlertController(title: "Seuil Dépassé", message: "Vous devez entrer une nouvelle valeur de seuil", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            
            }
            
            
        }
    }
    
    
    func updatedevicetoken(){
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
            let id = UserDefaults.standard.string(forKey: "idUser")
            print(deviceToken)
            print(id!)
            Alamofire.request(Common.Global.LOCAL + "/add_device_id_ios",method: .post, parameters: ["num_contrat" : id!,"token" : deviceToken], encoding: URLEncoding.httpBody)
        } else {
            print("devicetoken nil")
        }
        
    }

}
