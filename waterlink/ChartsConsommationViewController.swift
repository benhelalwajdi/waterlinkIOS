//
//  ChartsConsommationViewController.swift
//  waterlink
//
//

import UIKit
import Charts
import SocketIO
import Alamofire
import SwiftyJSON



class ChartsConsommationViewController: UIViewController, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm.ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }

   
    var months: [String]!
    var consommation_mensuel: [Double]=[]
    var transactionArray : NSMutableArray = []
     var data: [JSON] = []
    let consommation = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    var total_mois :Double = 0.0
    var dataEntries: [ChartDataEntry] = []
    var AuctionTimer: Timer!
    let message = "hello"
    let num_contrat = UserDefaults.standard.string(forKey: "idUser")!
    var values:[Double]=[]
    var val:[Double]=[]


    @IBOutlet weak var valuelabel: UILabel!
    @IBAction func StartChart(_ sender: Any) {
//        self.setSocketEvents();
        //       setChart(values: [24.0,43.0,56.0,23.0,56.0,68.0,48.0,120.0,41.0])
//        socket.connect()
//        self.socket.emit("user_id", self.num_contrat)
        //       self.setChart(values: (self.values))
        
//        addHandlers()
    }
    @IBOutlet weak var quantiteLabel: UILabel!
    @IBOutlet weak var startbtn: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var Barchart: BarChartView!
    @IBOutlet weak var Linechart: LineChartView!
    @IBAction func ViewChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            startbtn.isHidden = true
            valuelabel.isHidden = false
            Barchart.isHidden = true
            Linechart.isHidden = false
            self.setSocketEvents();
//                  setChart(values: [24.0,43.0,56.0,23.0,56.0,68.0,48.0,120.0,41.0])
                  socket.connect()
                    self.socket.emit("user_id", self.num_contrat)

               addHandlers()
            
        case 1:
            quantiteLabel.isHidden = true
            startbtn.isHidden = true
            valuelabel.isHidden = true
            Barchart.isHidden = true
            Linechart.isHidden = true
            self.socket.emit("user_disconnected", self.message)

            //timer = NSTimer.scheduledTimerWithTimeInterval(0.010, target:self, selector: #selector(), userInfo: nil, repeats: true)

            
        case 2:
            quantiteLabel.isHidden = true
            startbtn.isHidden = true
            valuelabel.isHidden = true
            Barchart.isHidden = false
            Linechart.isHidden = true
            self.data = []
            Alamofire.request(Common.Global.LOCAL + "/consommation_mensuel/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
                response in
                let resultJson = JSON(response.result.value!)
                self.transactionArray = (response.result.value as! NSArray).mutableCopy() as! NSMutableArray
                if self.transactionArray.count != 0{
                    for index in 0...self.transactionArray.count - 1{
                        let id_mois : Int = resultJson[index]["id_mois"].intValue
                        self.total_mois = resultJson[index]["total_mois"].doubleValue
//                        print(total_mois)
                        self.consommation_mensuel.append(self.total_mois)
                    }
                  
                    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
                    
                    let test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                    
                    var dataEntries: [BarChartDataEntry] = []
                    
                    for i in 0..<self.months.count
                    {
                        let dataEntry = BarChartDataEntry(x: Double(test[i]), y:self.consommation_mensuel[i])
                        
                        dataEntries.append(dataEntry)
                    }
                    
                    let chartDataSet = BarChartDataSet(values: dataEntries, label: "Consommation mensuel")
                    let chartData = BarChartData(dataSet: chartDataSet)
                    self.Barchart.data = chartData
                    chartDataSet.colors = ChartColorTemplates.colorful()
        
                    self.Barchart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                    self.Barchart.animate(yAxisDuration: 0.2)
                    self.Barchart.xAxis.labelPosition = .bottom
                    self.Barchart.xAxis.labelTextColor = UIColor.blue
                    self.Barchart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
//                    self.Barchart.rightAxis.addLimitLine(<#T##line: ChartLimitLine##ChartLimitLine#>)
                    self.Barchart.setVisibleYRange(minYRange: 0, maxYRange: 10, axis: .left)

                    
                    
                    //                    print(self.consommation_mensuel)
//                    self.months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//                    let consommation = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//                    self.setChart(dataPoints: self.months, values: consommation)
//                    self.months = ["Jan", "Feb", "Mar"]
//                   self.setChart(dataPoints: self.months, values: self.consommation_mensuel)
                }
            }
          
            self.socket.emit("user_disconnected", self.message)

        default:
            break;
        }
    }
    let manager = SocketManager(socketURL: URL(string: Common.Global.LOCAL)!, config: [.log(true),.compress])
    var socket:SocketIOClient!
    override func viewDidLoad() {
        self.socket = manager.defaultSocket
        startbtn.isHidden = true
        valuelabel.isHidden = true
        Barchart.isHidden = true
//        getData_Mensuel()
        months = ["Jan", "Feb", "Mar"]

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    func addHandlers() {
        self.socket.on("message") {[weak self]data, ack in
            if let cur = data[0] as? Double {
                //            DispatchQueue.main.async(execute: {
                self!.valuelabel.text = String(cur)
                self!.values.append(cur)
                self!.updateChart()

                //            })
            }
            
        }
//        self.setChart(values: (self.values))
        
    }
    private func setSocketEvents()
    {
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected");
        };
        
        
    };
    private func updateChart() {
        Linechart.noDataText = "No data available!"
        var chartEntry = [ChartDataEntry]()
        
        for i in 0..<values.count {
            let value = ChartDataEntry(x: Double(i), y: values[i])
            chartEntry.append(value)
        }
        
        let line = LineChartDataSet(values: chartEntry, label: "Visitor")
        line.colors = [UIColor.green]
        
        let data = LineChartData()
        data.addDataSet(line)
        
       Linechart.data = data
        Linechart.chartDescription?.text = "Consommation Count"
    }
    func setChart(values: [Double]) {
        Linechart.noDataText = "No data available!"
        for i in 0..<values.count {
            print("chart point : \(values[i])")
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let line1 = LineChartDataSet(values: dataEntries, label: "Units Consumed")
        line1.colors = [NSUIColor.blue]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        
        let gradient = getGradientFilling()
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData()
        data.addDataSet(line1)
        Linechart.data = data
        Linechart.setScaleEnabled(false)
        Linechart.animate(xAxisDuration: 1.5)
        Linechart.drawGridBackgroundEnabled = false
        Linechart.xAxis.drawAxisLineEnabled = false
        Linechart.xAxis.drawGridLinesEnabled = false
        Linechart.leftAxis.drawAxisLineEnabled = false
        Linechart.leftAxis.drawGridLinesEnabled = false
        Linechart.rightAxis.drawAxisLineEnabled = false
        Linechart.rightAxis.drawGridLinesEnabled = false
        Linechart.legend.enabled = false
        Linechart.xAxis.enabled = false
        Linechart.leftAxis.enabled = false
        Linechart.rightAxis.enabled = false
        Linechart.xAxis.drawLabelsEnabled = false
        
    }
    
    func getData_Mensuel(){
        self.data = []
        Alamofire.request(Common.Global.LOCAL + "/consommation_mensuel/" + UserDefaults.standard.string(forKey: "idUser")!).responseJSON{
            response in
            let resultJson = JSON(response.result.value!)
            self.transactionArray = (response.result.value as! NSArray).mutableCopy() as! NSMutableArray
            if self.transactionArray.count != 0{
                for index in 0...self.transactionArray.count - 1{
                    let id_mois : Int = resultJson[index]["id_mois"].intValue
                    let total_mois : Double = resultJson[index]["total_mois"].doubleValue
                    print(total_mois)
    
          self.consommation_mensuel.append(total_mois)
        
        }
        }
    }
      }
//    func setChart(dataPoints: [String], values: [Double]) {
//        Barchart.noDataText = "You need to provide data for the chart."
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Consommation")
//        let chartData = BarChartData(dataSet: chartDataSet)
//        Barchart.data = chartData
//
//    }
    

    func setChart()
    {
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        let test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count
        {
            let dataEntry = BarChartDataEntry(x: Double(test[i]), y: Double(unitsSold[i]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        Barchart.data = chartData
    }
    
    /// Creating gradient for filling space under the line chart
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let coloTop = UIColor(red: 141/255, green: 133/255, blue: 220/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 1).cgColor
        // Colors of the gradient
        let gradientColors = [coloTop, colorBottom] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }  }



