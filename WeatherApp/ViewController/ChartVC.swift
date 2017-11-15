//
//  ChartVC.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 14.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartVC: UIViewController, IAxisValueFormatter {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter? // delegate for x axis formatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
        lineChartView.noDataText = "There is no data at the moment."
        updateChartWithData()
        
    }
    
    //MARK: - Configure and fill chart with data
    private func updateChartWithData() {
        var tempDataEntries = [ChartDataEntry]()
        var windDataEntries = [ChartDataEntry]()
        let weatherArray = getWeatherArray()
        
        //return if we have only one day or less in CoreData
        if weatherArray.count <= 1 {
            self.showAlertWith(title: "Error", message: "There is not enough data to show chart", style: .alert)
            return
        }
        
        //var lastUpdatedTemp = 0.0
        for i in weatherArray {
            if let timeIntervalForDate: TimeInterval = i.lastUpdated?.timeIntervalSince1970 {
                //uncomment to filter data for the same day
                //let date1 = Date(timeIntervalSinceReferenceDate: timeIntervalForDate)
                //let date2 = Date(timeIntervalSinceReferenceDate: lastUpdatedTemp)
                //if !Calendar.current.isDate(date1, inSameDayAs:date2) {
                    //lastUpdatedTemp = timeIntervalForDate
                    let tempEntry = ChartDataEntry(x: timeIntervalForDate, y: i.tempC)
                    let windEntry = ChartDataEntry(x: timeIntervalForDate, y: i.windKph)
                    tempDataEntries.append(tempEntry)
                    windDataEntries.append(windEntry)
                //}
            }
            
        }
        let tempDataSet = LineChartDataSet(values: tempDataEntries, label: "Temp C")
        let windDataSet = LineChartDataSet(values: windDataEntries, label: "Wind kph")
        tempDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        windDataSet.colors = [UIColor.black]
        let chartData = LineChartData(dataSets: [tempDataSet, windDataSet])
        
        lineChartView.data = chartData
        lineChartView.chartDescription?.text = "Moscow weather"
        lineChartView.xAxis.labelPosition = .bottom
        let xaxis = lineChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    private func getWeatherArray() -> [Weather] {
        // read data from Core Data and sort by date
        do {
            let request : NSFetchRequest<Weather> = Weather.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: true)]
            let array = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            return array
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

    //MARK: - Button action
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Axis formatter delegate methods
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        // configure date display format
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
    
}
