//
//  CountryCodeViewController.swift
//  CountryList-Swift
//
//  Created by Sai Ram Kotha on 30/03/16.
//
//

import UIKit

class CountryCodeViewController: UIViewController {
  
  var selectedCountry: Country!
  
  @IBOutlet weak var countryLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
  
    let pickCountry = UIButton()
    pickCountry.setTitle("Pick a Country", for: UIControlState())
    pickCountry.setTitleColor(.black, for: UIControlState())
    pickCountry.frame = CGRect(x: 50, y: 100, width: 200, height: 40)
    view.addSubview(pickCountry)
    
    pickCountry.addTarget(self, action: #selector(CountryCodeViewController.showCountryViewScreen), for: UIControlEvents.touchUpInside)
    
  }
  
  func showCountryViewScreen() {
    self.performSegue(withIdentifier: "countryScreen", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "countryScreen" {
      if let control = segue.destination as? UINavigationController {
        if let contrl = control.topViewController as? SRCountryPickerController {
          contrl.countryDelegate = self
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}

extension CountryCodeViewController: CountrySelectedDelegate {
  
  func SRcountrySelected(countrySelected country: Country) {
    self.selectedCountry = country
    print("country selected  code \(self.selectedCountry.country_code), country name \(self.selectedCountry.country_name), dial code \(self.selectedCountry.dial_code)")
    countryLabel.text =  "country selected ''\(self.selectedCountry.country_name)''"
  }
  
}
