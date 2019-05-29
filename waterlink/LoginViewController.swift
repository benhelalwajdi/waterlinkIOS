//
//  LoginViewController.swift
//  waterlink
//
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var numContratTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoadView()
        
        // Do any additional setup after loading the view.
    }
    
    func onLoadView(){
        numContratTextField.delegate = self
        self.numContratTextField.keyboardType = UIKeyboardType.decimalPad
        validerButton.clipsToBounds = true
        validerButton.layer.cornerRadius = 25.0
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 70.0
        myView.layer.cornerRadius = 10.0
        myView.layer.shadowPath =
            UIBezierPath(roundedRect: self.myView.bounds,
                         cornerRadius: 10).cgPath
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowOffset = CGSize(width: 10, height: 10)
        myView.layer.shadowRadius = 1
        myView.layer.masksToBounds = false
    }

    func sendData(){
        Alamofire.request(Common.Global.LOCAL + "/login",method: .post, parameters: ["num_contrat" : numContratTextField.text!,"password" : passwordTextField.text!], encoding: URLEncoding.httpBody).responseJSON(completionHandler: {
            response in
            let jsonResponse = JSON(response.result.value!)
            if jsonResponse["message"].string == "Mot de Passe incorrect" {
                let alert = UIAlertController(title: "Erreur", message: "Mot de passe Incorrect", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            if jsonResponse["message"].string == "Num Contrat incorrect"  {
                let alert = UIAlertController(title: "Erreur", message: "Numéro de contrat incorrect", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            } else {
                UserDefaults.standard.setValue(self.numContratTextField.text, forKey: "idUser")
                self.numContratTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        })
    }
    
    @IBAction func validerTapped(_ sender: Any) {
        if(numContratTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Erreur", message: "Champs vide", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        } else {
            sendData()

        }
    }
    //Delegate textField method to authorize only numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"+0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    

}
