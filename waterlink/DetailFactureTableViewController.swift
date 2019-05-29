//
//  DetailFactureTableViewController.swift
//  waterlink
//
//

import UIKit
import Alamofire
import SwiftyJSON
import SimplePDF

class DetailFactureTableViewController: UITableViewController {

    @IBOutlet weak var idContratLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var eauTotalLabel: UILabel!
    @IBOutlet weak var totalSonedeSansTvaLabel: UILabel!
    @IBOutlet weak var totalSonedeAvecTvaLabel: UILabel!
    @IBOutlet weak var totalOnasLabel: UILabel!
    @IBOutlet weak var prixTotalLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    
    var idFacture : String?
    var firstPeriod : String?
    
    var colorBlue = UIColor(red: 35/255, green: 85/255, blue: 150/255, alpha: 1.0)
    private var pdfFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else if section == 1 {
            return 5
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func getData(){
        print(self.idFacture)
        Alamofire.request(Common.Global.LOCAL + "/get_facturedetails/" + UserDefaults.standard.string(forKey: "idUser")! + "/" + self.idFacture!).responseJSON{
            response in
            let jsonResponse = JSON(response.result.value)
            print(jsonResponse)
            let contratID = jsonResponse[0]["id_user"].stringValue
            let region = jsonResponse[0]["region"].stringValue
            let adresse = jsonResponse[0]["adresse"].stringValue
            let nom = jsonResponse[0]["nom"].stringValue
            let eauTotal = jsonResponse[0]["total_litres"].floatValue / 1000
            let prixSansTva = (jsonResponse[0]["prix_sonede"].floatValue) / 1000
            let prixAvecTva = ((prixSansTva + 5900) * 0.19 + prixSansTva) / 1000
            let totalOnas = jsonResponse[0]["prix_onas"].floatValue / 1000
            let prixTotal = jsonResponse[0]["prix_facture"].floatValue / 1000
            let firstPeriod = jsonResponse[0]["date_debut"].stringValue
            let endPeriod = jsonResponse[0]["date_fin"].stringValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let firstDateObj = dateFormatter.date(from: firstPeriod)
            let finalDateObj = dateFormatter.date(from: endPeriod)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let finalFirstPeriod = dateFormatter.string(from: firstDateObj!)
            let finalPeriod = dateFormatter.string(from: finalDateObj!)

            
            
            self.idContratLabel.text = contratID
            self.regionLabel.text = region
            self.adresseLabel.text = adresse
            self.userNameLabel.text = nom
            self.eauTotalLabel.text = String(eauTotal)
            self.totalSonedeSansTvaLabel.text = String(prixSansTva)
            self.totalSonedeAvecTvaLabel.text = String(prixAvecTva)
            self.totalOnasLabel.text = String(totalOnas)
            self.prixTotalLabel.text = String(prixTotal)
            self.periodLabel.text = "Du " + finalFirstPeriod + " Au " + finalPeriod
        }
        
    }
    
    
    
    
    @IBAction func generatePdfTapped(_ sender: Any) {
        self.convert1()
    }
    
    func genereatePDF() -> String?{
        let a4PaperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: a4PaperSize)
        let logoImage = UIImage(named:"AppIcon")!
        pdf.setContentAlignment(.center)
        //pdf.addImage(logoImage)
        pdf.addText("WATERLINK", font: UIFont(name: "Courier", size: 70.0)!, textColor: .black)
        pdf.addLineSpace(30)
        pdf.setContentAlignment(.left)
        pdf.addLineSeparator()
        pdf.addLineSpace(20.0)
        
        pdf.addText("Contrat: " + self.idContratLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Région: " + self.regionLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Adresse: " + self.adresseLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Nom: " + self.userNameLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(20.0)
        pdf.addLineSeparator()
        pdf.addLineSpace(20.0)
        pdf.addText("Consommation totale en m3: " + self.eauTotalLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Total Sonede en DT: " + self.totalSonedeSansTvaLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Total Sonede + TVA en DT: " + self.totalSonedeAvecTvaLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(3.0)
        pdf.addText("Total Onas en DT: " + self.totalOnasLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        pdf.addLineSpace(20.0)
        pdf.addLineSeparator()
        pdf.addLineSpace(20.0)
        pdf.addText("Total en DT: " + self.prixTotalLabel.text!, font: UIFont(name: "Courier", size: 25.0)!, textColor: .black)
        
        let pdfData = pdf.generatePDFdata()
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first as! URL
        let pdfNameFromUrl = "facture.pdf"
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
        do {
            try pdfData.write(to: actualPath, options: .atomic)
            print("pdf successfully saved!")
        } catch {
            print("Pdf could not be saved")
        }
        return actualPath.path
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let path = self.pdfFilePath else {
            fatalError()
        }
        
        if let destinationVC =  segue.destination as? PdfPreviewViewController {
           
                destinationVC.pdfFilePath = path
            
        }
    }
    
    @objc func navigate() {
        self.performSegue(withIdentifier: "PdfPreview", sender: nil)
    }
    
    @objc func convert1() {
        guard let path = self.genereatePDF() else {
            return
        }
        
        self.pdfFilePath = path
        self.navigate()
    }
    
    
    
    
    func getActualDate() -> String {
        let currentDateTime = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let month = calendar.component(.month, from: currentDateTime)
        let year = calendar.component(.year, from: currentDateTime)
        
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: currentDateTime)
        
        return "Du " + self.firstPeriod! + " au " + result
    }

}
extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
