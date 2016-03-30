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
  var countries = NSArray()
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
    tableView.registerClass(CountryTableViewCell.self, forCellReuseIdentifier: "cell")
  }

  func jsonSerial() {
    let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("countries", ofType: "json")!)
     do {
     let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
      countries = parsedObject as! NSArray
//      print("country list \(countries)")
     }catch{
      print("not able to parse")
    }
  }
  
  func collectCountries() {
    for i in 0 ..< countries.count  {
      let code = countries[i]["code"] as! String
      let name = countries[i]["name"] as! String
      let dailcode = countries[i]["dial_code"] as! String
      countriesModel.append(Country(country_code:code,dial_code:dailcode, country_name:name))
    }
  }
  
  func filtercountry(searchText: String) {
    countriesFiltered = countriesModel.filter({(country ) -> Bool in
     let value = country.country_name.lowercaseString.containsString(searchText.lowercaseString) || country.country_code.lowercaseString.containsString(searchText.lowercaseString)
      return value
    })
    tableView.reloadData()
  }
  
  func checkSearchBarActive() -> Bool {
    if searchBar.isFirstResponder() && searchBar.text != "" {
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
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    self.filtercountry(searchText)
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
}


extension SRCountryPickerController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if checkSearchBarActive() {
      return countriesFiltered.count
    }
    return countries.count
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if checkSearchBarActive() {
      countryDelegate.SRcountrySelected(countrySelected: countriesFiltered[indexPath.row])
    }else {
      countryDelegate.SRcountrySelected(countrySelected: countriesModel[indexPath.row])
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}

extension SRCountryPickerController : UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CountryTableViewCell
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
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
}
