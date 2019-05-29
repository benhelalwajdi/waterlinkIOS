//
//  ChartsViewController.swift
//  waterlink
//
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON



class ChartsViewController: UIViewController {
    
    var months: [String]!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let consommation = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: consommation)
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
            
            
//            self.regiontxt.text = region
//            self.Nomtxt.text = nom + prenom
//            self.phonetxt.text = String(numtel)
//            self.emaailtxt.text = mail
//            self.codepostaltxt.text = String(codepostal)
//            self.locationtxt.text = region
//            self.adressetxt.text = region
            
        }
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Consommation")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
    }

}
