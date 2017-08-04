//
//  ViewController.swift
//  weatherForcast2
//
//  Created by Jacob Claessens on 2016-05-21.
//  Copyright © 2016 Rover Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var cityTextField: UITextField!
    
    
    @IBOutlet var answerLabel: UILabel!
    
    
    @IBAction func searchButton(_ sender: AnyObject) {
    
        let urlAttempt = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")
        
        var wasSuccessful = false
        
        cityTextField.text = ""
        
        if let url = urlAttempt {
            
            //start the task
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, responce, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: String.Encoding.utf8.rawValue)
                    
                    let webSiteArr = webContent?.components(separatedBy: "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if webSiteArr!.count > 1 {
                        
                        let secWeathArr = webSiteArr![1].components(separatedBy: "</span></span></span></p><div")
                        
                        if secWeathArr.count > 1 {
                            
                            let weathSum = secWeathArr[0]
                            
                            wasSuccessful = true
                            
                            DispatchQueue.main.async(execute: {
                                self.answerLabel.text = weathSum
                            })
                        }
                    }
                }
                if wasSuccessful == false {
                    self.answerLabel.text = "Couldn't find the weather, try again"
                }
            }) 
            task.resume()
        } else {
            self.answerLabel.text = "couldn't unwrap the url, try again"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTextField.delegate = self   //line deligate is responsible for city txt field
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

