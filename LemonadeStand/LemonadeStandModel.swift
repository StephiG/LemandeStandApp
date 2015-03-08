//
//  LemonadeStandModel.swift
//  LemonadeStand
//
//  Created by Stephi Goering on 20/02/15.
//  Copyright (c) 2015 Stephi Goering. All rights reserved.
//

import Foundation

class LemonadeStandModel {
    
    class func createLemonadeRatio (lemons: Int, ice: Int) -> Double {
        var ratio =  Double(lemons) / Double(ice)
        return ratio
    }
    
    class func getWeatherForTheDay () -> String {
        var currentWeather = ""
        var randomNumberForWeather = Int(arc4random_uniform(UInt32(2)))
        switch randomNumberForWeather {
        case 0:
            currentWeather = "Cold"
        case 1:
            currentWeather = "mild"
        case 2:
            currentWeather = "warm"
        default:
            currentWeather = "mild"
        }
        
        return currentWeather
    }
    
    class func createCustomersForTheDay (weather: String) -> [Double]{
        var listOfCustomersPreference: [Double] = []
        var randomNumberOfCustomers = Int(arc4random_uniform(UInt32(10)))

        if weather == "warm" {
            randomNumberOfCustomers += 4
        } else if weather == "cold" {
            randomNumberOfCustomers -= 3
        }
        println("randomNumber:\(randomNumberOfCustomers)")
        for var numberOfCustomers = 0; numberOfCustomers < randomNumberOfCustomers + 5; numberOfCustomers++ {
            var randomNumber = Int(arc4random_uniform(UInt32(11)))
            var customerPreference = Double(randomNumber) / 10.0
            listOfCustomersPreference.append(customerPreference)
        }
        
        return listOfCustomersPreference
    }
    
    class func countEarnings (lemonadeRatio: Double, customerList: [Double] ) -> Int {
        println("\(customerList.count)")
        var earnings = 0
        for customerPreference in customerList {
            if customerPreference <= 0.4 && lemonadeRatio > 1 {
                println("preference value: \(customerPreference) Paid!")
                earnings += 1
            } else if customerPreference >= 0.6 && lemonadeRatio < 1 {
                println("preference value: \(customerPreference) Paid!")
                earnings += 1
            } else if customerPreference >= 0.4 && customerPreference <= 0.6 && lemonadeRatio == 1 {
                println("preference value: \(customerPreference) Paid!")
                earnings += 1
            } else {
                println("preference value: \(customerPreference) No match, no Revenue!")
            }
        }
        
        return earnings
    }
}

