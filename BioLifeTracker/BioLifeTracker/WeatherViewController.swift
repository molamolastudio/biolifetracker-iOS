//
//  WeatherViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 20/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  Presents a bar of weather icons for selection.
//  It has 2 states: no weather type is selected, or 1 weather type is selected.
//  Returns a Weather object to its delegate after a weather type is selected.

import UIKit

class WeatherViewController: UIViewController {
    var delegate: WeatherViewControllerDelegate? = nil
    
    let weatherNames = ["Clear", "Sunny", "Cloudy", "Partly Cloudy", "Rainy", "Stormy", "Windy"]
    
    var selectedWeather: Weather? = nil
    var selectedIndex: Int? = nil
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("WeatherView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAsSelected(selectedIndex)
        
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = true;
    }
    
    func setWeather(weather: Weather?) {
        selectedIndex = nil
        if weather != nil && weather!.weather != "" {
            selectedIndex = getIndexOfWeather(weather!.weather)
        }
        
        setButtonAsSelected(selectedIndex)
    }
    
    func getSelectedWeather() -> Weather? {
        if selectedIndex != nil {
            return Weather(weather: weatherNames[selectedIndex!])
        }
        return nil
    }
    
    @IBAction func btnPressed(sender: UIButton) {
        let btnIndex = sender.tag - 1
        if btnIndex == selectedIndex {
            selectedIndex = nil
        } else {
            selectedIndex = btnIndex
        }
        setButtonAsSelected(selectedIndex)
        
        if delegate != nil {
            delegate!.userDidSelectWeather(getSelectedWeather())
        }
    }
    
    func setButtonAsSelected(index: Int?) {
        for i in 0...weatherNames.count - 1 {
            let button = self.view.viewWithTag(i + 1) as! UIButton
            button.highlighted = (index != i)
        }
    }
    
    func getIndexOfWeather(weather: String) -> Int? {
        for i in 0...weatherNames.count - 1 {
            if weatherNames[i] == weather {
                return i
            }
        }
        return nil
    }
}
