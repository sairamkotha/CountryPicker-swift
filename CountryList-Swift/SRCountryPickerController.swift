//
//  ViewController.swift
//  CountryList-Swift
//
//  Created by Sai Ram Kotha on 29/01/16.
//  
//


import Foundation
import UIKit

struct Country {
  let country_code : String
  let dial_code: String
  let country_name : String
}

protocol CountrySelectedDelegate {
  func SRcountrySelected(countrySelected country: Country) -> Void
}

class SRCountryPickerController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
    var countries = [[String: String]]()
  var countryDelegate: CountrySelectedDelegate!
  var countriesFiltered = [Country]()
  var countriesModel = [Country]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    jsonSerial()
    collectCountries()
    self.title = "COUNTRIES"
    searchBar.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsMultipleSelection = false
    tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "cell")
  }

  func jsonSerial() {
    let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "countries", ofType: "json")!))
     do {
     let parsedObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
      countries = parsedObject as! [[String : String]]
//      print("country list \(countries)")
     }catch{
      print("not able to parse")
    }
  }
  
  func collectCountries() {
    for country in countries  {
      let code = country["code"] ?? ""
      let name = country["name"] ?? ""
      let dailcode = country["dial_code"] ?? ""
      countriesModel.append(Country(country_code:code,dial_code:dailcode, country_name:name))
    }
  }
  
  func filtercountry(_ searchText: String) {
    countriesFiltered = countriesModel.filter({(country ) -> Bool in
     let value = country.country_name.lowercased().contains(searchText.lowercased()) || country.country_code.lowercased().contains(searchText.lowercased())
      return value
    })
    tableView.reloadData()
  }
  
  func checkSearchBarActive() -> Bool {
    if searchBar.isFirstResponder && searchBar.text != "" {
      return true
    }else {
      return false
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension SRCountryPickerController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.filtercountry(searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
}


extension SRCountryPickerController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if checkSearchBarActive() {
      return countriesFiltered.count
    }
    return countries.count
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if checkSearchBarActive() {
      countryDelegate.SRcountrySelected(countrySelected: countriesFiltered[indexPath.row])
    }else {
      countryDelegate.SRcountrySelected(countrySelected: countriesModel[indexPath.row])
    }
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension SRCountryPickerController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountryTableViewCell
    let contry: Country
    if checkSearchBarActive() {
      contry = countriesFiltered[indexPath.row]
    }else{
      contry = countriesModel[indexPath.row]
    }
    cell.textLabel?.text = contry.country_name
    cell.detailTextLabel?.text = contry.dial_code
    let imagestring = contry.country_code
    let imagePath = "CountryPicker.bundle/\(imagestring).png"
    cell.imageView?.image = UIImage(named: imagePath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
}
