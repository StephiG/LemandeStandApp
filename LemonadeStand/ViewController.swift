//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Stephi Goering on 28/01/15.
//  Copyright (c) 2015 Stephi Goering. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // status display (labels, image view)
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var currentMoneyLabel: UILabel!
    @IBOutlet weak var currentLemonStockLabel: UILabel!
    @IBOutlet weak var currentIceCubeStockLabel: UILabel!
    
    @IBOutlet weak var weatherDisplay: UIImageView!
    
    // step 1 labels
    @IBOutlet weak var amountLemonsBoughtLabel: UILabel!
    @IBOutlet weak var amountIceCubesBoughtLabel: UILabel!
    
    // step 2 labels
    @IBOutlet weak var lemonsInBrewLabel: UILabel!
    @IBOutlet weak var iceCubesInBrewLabel: UILabel!
    @IBOutlet weak var tasteStatusLabel: UILabel!
    
    // buttons
    @IBOutlet weak var oneLessLemonBoughtButton: UIButton!
    @IBOutlet weak var oneMoreLemonBoughtButton: UIButton!
    @IBOutlet weak var oneLessIceCubeBoughtButton: UIButton!
    @IBOutlet weak var oneMoreIceCubeBoughtButton: UIButton!
    
    @IBOutlet weak var oneLessLemonInBrewButton: UIButton!
    @IBOutlet weak var oneMoreLemonInBrewButton: UIButton!
    @IBOutlet weak var oneLessIceCubeInBrewButton: UIButton!
    @IBOutlet weak var oneMoreIceCubeInBrewButton: UIButton!

    // status variables
    var daysPlayed = 0
    var currentWeather = "mild"
    var currentAmountMoneyOwned = 10
    var currentAmountOfLemonsInStock = 1
    var currentAmountOfIceCubesInStock = 1
    
    // variables for buying and brewing
    var amountOfLemonsBought = 0
    var amountOfIceCubesBought = 0
    var amountOfLemonsInBrew = 0
    var amountOfIceCubesInBrew = 0
    var currentTaste = "ballenced"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // step 1 buttons
    @IBAction func oneLessLemonBoughtButtonPressed(sender: UIButton) {
        amountOfLemonsBought -= 1
        currentAmountMoneyOwned += 2
        amountLemonsBoughtLabel.text = "\(amountOfLemonsBought)"
        currentAmountOfLemonsInStock -= 1
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
    }
    
    @IBAction func oneLessIceCubeBoughtButtonPressed(sender: UIButton) {
        amountOfIceCubesBought -= 1
        currentAmountMoneyOwned += 1
        amountIceCubesBoughtLabel.text = "\(amountOfIceCubesBought)"
        currentAmountOfIceCubesInStock -= 1
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
    }
    
    @IBAction func oneMoreLemonBoughtButtonPressed(sender: UIButton) {
        amountOfLemonsBought += 1
        currentAmountMoneyOwned -= 2
        amountLemonsBoughtLabel.text = "\(amountOfLemonsBought)"
        currentAmountOfLemonsInStock += 1
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
    }
    
    @IBAction func oneMoreIceCubeBoughtButtonPressed(sender: UIButton) {
        amountOfIceCubesBought += 1
        currentAmountMoneyOwned -= 1
        amountIceCubesBoughtLabel.text = "\(amountOfIceCubesBought)"
        currentAmountOfIceCubesInStock += 1
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
    }
    
    // step 2 buttons
    @IBAction func oneLessLemonInBrewButtonPressed(sender: UIButton) {
        amountOfLemonsInBrew -= 1
        currentAmountOfLemonsInStock += 1
        lemonsInBrewLabel.text = "\(amountOfLemonsInBrew)"
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
        updateTasteStatus (amountOfLemonsInBrew , icecubes: amountOfIceCubesInBrew)
    }
    
    @IBAction func oneLessIceCubeInBrewButtonPressed(sender: UIButton) {
        amountOfIceCubesInBrew -= 1
        currentAmountOfIceCubesInStock += 1
        iceCubesInBrewLabel.text = "\(amountOfIceCubesInBrew)"
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
        updateTasteStatus (amountOfLemonsInBrew , icecubes: amountOfIceCubesInBrew)
    }

    @IBAction func oneMoreLemonInBrewButtonPressed(sender: UIButton) {
        amountOfLemonsInBrew += 1
        currentAmountOfLemonsInStock -= 1
        lemonsInBrewLabel.text = "\(amountOfLemonsInBrew)"
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
        updateTasteStatus (amountOfLemonsInBrew , icecubes: amountOfIceCubesInBrew)
    }
    
    @IBAction func oneMoreIceCubeInBrewButtonPressed(sender: UIButton) {
        amountOfIceCubesInBrew += 1
        currentAmountOfIceCubesInStock -= 1
        iceCubesInBrewLabel.text = "\(amountOfIceCubesInBrew)"
        updateStatusOfAllButtons()
        updateStatusViewDuringDay()
        updateTasteStatus (amountOfLemonsInBrew , icecubes: amountOfIceCubesInBrew)
    }
    
    // start selling
    @IBAction func startSellingButtonPressed(sender: UIButton) {
        var customerList = LemonadeStandModel.createCustomersForTheDay(currentWeather)
        
        if (amountOfLemonsInBrew + amountOfIceCubesInBrew) * 2 < customerList.count {
            do {
               customerList.removeLast()
            } while (amountOfLemonsInBrew + amountOfIceCubesInBrew) < customerList.count * 2
        }
        
        var lemonadeRatio = LemonadeStandModel.createLemonadeRatio(amountOfLemonsInBrew, ice: amountOfIceCubesInBrew)
        var earnings = LemonadeStandModel.countEarnings(lemonadeRatio, customerList: customerList)
        
        currentAmountMoneyOwned += earnings
        daysPlayed += 1
        currentWeather = LemonadeStandModel.getWeatherForTheDay()
        if currentAmountMoneyOwned == 0 && currentAmountOfIceCubesInStock == 0 && currentAmountOfLemonsInStock == 0 {
            showAlertWithText(header: "Sales Report", message: "You had \(customerList.count) customers. You earned \(earnings)$. You didn't earn enough to get new ingredients for you lemmonade. So you are bankrupt and you need to start over again.")
            hardReset()
        } else {
            showAlertWithText(header: "Sales Report", message: "You had \(customerList.count) customers. You earned \(earnings)$.")
            updateViewAfterDayPlayed()
        }
        currentWeather = LemonadeStandModel.getWeatherForTheDay()
    }

    @IBAction func resetButtonPressed(sender: UIButton) {
        showAlertWithText(header: "Restart", message: "You pressed the reset button and so you are starting form the beginning.")
        hardReset()
    }
    // checking the appropiate status of the buttons
    
    func updateStatusOfAllButtons() {
        // button for buying one less lemon
        if amountOfLemonsBought == 0 {
            oneLessLemonBoughtButton.enabled = false
        } else {
            oneLessLemonBoughtButton.enabled = true
        }
        
        // button for buying one less ice cube
        if amountOfIceCubesBought == 0 {
            oneLessIceCubeBoughtButton.enabled = false
        } else {
            oneLessIceCubeBoughtButton.enabled = true
        }
        
        // button for buying one more lemon
        if currentAmountMoneyOwned < 2 {
            oneMoreLemonBoughtButton.enabled = false
        } else {
            oneMoreLemonBoughtButton.enabled = true
        }
        
        // button for buying one more ice cube
        if currentAmountMoneyOwned < 1 {
            oneMoreIceCubeBoughtButton.enabled = false
        } else {
            oneMoreIceCubeBoughtButton.enabled = true
        }
        
        // button for one less lemon in brew
        if amountOfLemonsInBrew == 0 {
            oneLessLemonInBrewButton.enabled = false
        } else {
            oneLessLemonInBrewButton.enabled = true
        }
        
        // button for one less ice cube in brew
        if amountOfIceCubesInBrew == 0 {
            oneLessIceCubeInBrewButton.enabled = false
        } else {
            oneLessIceCubeInBrewButton.enabled = true
        }
        
        // button for one more lemon in brew
        if currentAmountOfLemonsInStock == 0 {
            oneMoreLemonInBrewButton.enabled = false
        } else {
            oneMoreLemonInBrewButton.enabled = true
        }
        
        // button for one more ice cube in brew
        if currentAmountOfIceCubesInStock == 0 {
            oneMoreIceCubeInBrewButton.enabled = false
        } else {
            oneMoreIceCubeInBrewButton.enabled = true
        }
        
        
    }
    
    // updating the view
    func updateStatusViewDuringDay() {
        currentMoneyLabel.text = "$\(currentAmountMoneyOwned)"
        currentLemonStockLabel.text = "\(currentAmountOfLemonsInStock)"
        currentIceCubeStockLabel.text = "\(currentAmountOfIceCubesInStock)"
    }
    
    func updateViewAfterDayPlayed() {
        dayCountLabel.text = "\(daysPlayed)"
        weatherLabel.text = currentWeather
        weatherDisplay.image = UIImage(named:currentWeather)
        currentMoneyLabel.text = "$\(currentAmountMoneyOwned)"
        currentLemonStockLabel.text = "\(currentAmountOfLemonsInStock)"
        currentIceCubeStockLabel.text = "\(currentAmountOfIceCubesInStock)"
        
        amountOfLemonsBought = 0
        amountOfIceCubesBought = 0
        amountOfLemonsInBrew = 0
        amountOfIceCubesInBrew = 0
        
        amountLemonsBoughtLabel.text = "0"
        amountIceCubesBoughtLabel.text = "0"
        lemonsInBrewLabel.text = "0"
        iceCubesInBrewLabel.text = "0"
        
        updateStatusOfAllButtons()
        
    }
    
    func updateTasteStatus(lemons: Int, icecubes: Int) {
        if lemons == 0 && icecubes == 0 {
            currentTaste = "balanced"
        } else {
            var ratio =  LemonadeStandModel.createLemonadeRatio(amountOfLemonsInBrew, ice:amountOfIceCubesInBrew)
            if ratio == 1 {
                currentTaste = "balanced"
            } else if ratio < 1 {
                currentTaste = "diluted"
            } else {
                currentTaste = "acidic"
            }
        }
        tasteStatusLabel.text = currentTaste
    }
    
    func hardReset() {
        daysPlayed = 0
        currentWeather = "mild"
        weatherDisplay.image = UIImage(named:"mild")
        currentAmountMoneyOwned = 10
        currentAmountOfLemonsInStock = 1
        currentAmountOfIceCubesInStock = 1
        updateViewAfterDayPlayed()
    }
    
    func showAlertWithText (header : String = "Warning", message : String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}

