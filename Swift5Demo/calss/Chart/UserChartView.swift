//
//  UserChartView.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/9/21.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import UIKit
import AAInfographics


class UserChartView: UIView {
    
    enum BasicChartVCChartType : Int {
        case column = 0
        case bar
        case area
        case areaspline
        case line
        case spline
        case stepLine
        case stepArea
        case scatter
    }
    var aaChartModel: AAChartModel = AAChartModel()
    var chartType: BasicChartVCChartType?
    var receivedChartType: String?
    
    lazy var aaChartView : AAChartView = {
        let chart = AAChartView.init()
        //禁用 AAChartView 滚动效果
        //设置 AAChartView 的背景色是否为透明
        chart.scrollEnabled = false
        chart.isClearBackgroundColor = false
        chart.delegate = self
        return chart
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(hexString: "#4b2b7f")
        drawChart()
    }
    func configureTheChartType() -> AAChartType {
        switch chartType {
        case .column:
            return AAChartType.column as AAChartType
        case .bar:
            return AAChartType.bar as AAChartType
        case .area:
            return AAChartType.area as AAChartType
        case .areaspline:
            return AAChartType.areaspline as AAChartType
        case .line:
            return AAChartType.line as AAChartType
        case .spline:
            return AAChartType.spline as AAChartType
        case .stepLine:
            return AAChartType.arearange
        case .stepArea:
            return AAChartType.areasplinerange
        case .scatter:
            return AAChartType.scatter
        default:
            break
        }
        return AAChartType.bar
    }
    
    
    func drawChart(){
        setupAAChartView()
//        self.chartType = .column
//        let chartType = configureTheChartType()
//        setupAAChartView(with: chartType)
//        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        
        aaChartView.aa_drawChartWithChartOptions(customColumnrangeChartStyle())
    }
    func setupAAChartView(){
        self.addSubview(self.aaChartView)
        self.aaChartView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setupAAChartView(with chartType:AAChartType){
        aaChartModel.chartType(chartType)
            .colorsTheme(["#fe117c", "#ffc069", "#06caf4"])
            .tooltipValueSuffix("℃")
            .yAxisLineWidth(1)
            .yAxisGridLineWidth(1)
            .series([
                AASeriesElement().name("2017").data([5.0, 5.9, 9.5, 9.5]),
                AASeriesElement().name("2018").data([6.0, 6.9, 10.5, 11]),
                AASeriesElement().name("2019").data([7.0, 7.9, 8.5, 10]),
            ])
        
        
        configureTheStyleForDifferentTypeChart()//为不同类型图表设置样式
        configureTheYAxisPlotLineForAAChartView()/*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
        
    }
    
    
    
    func configureTheStyleForDifferentTypeChart(){//为不同类型图表设置样式
        aaChartModel.categories(["Java", "Swift", "Python","OC"])//设置 X 轴坐标文字内容
            .animationType(.easeOutCubic)//图形的渲染动画类型为 EaseOutCubic
            .animationDuration(1200)//图形渲染动画时长为1200毫秒
    }
    /**
     *   图表 Y 轴标示线的设置
     *   标示线设置作为图表一项基础功能,用于对图表的基本数据水平均线进行标注
     *   虽然不太常被使用,但我们仍然提供了此功能的完整接口,以便于有特殊需求的用户使用
     *   解除👆上面的设置 Y 轴标注线的已被注释代码,,运行程序,即可查看实际工程效果以酌情选择
     *
     **/
    
    func configureTheYAxisPlotLineForAAChartView(){/*配置 Y 轴标注线,解开注释,即可查看添加标注线之后的图表效果(NOTE:必须设置 Y 轴可见)*/
        aaChartModel.aa_toAAOptions().yAxis?.plotLines(
            [AAPlotLinesElement()
                .color("#F05353")
                .dashStyle(.longDashDot)
                .width(1)
                .value(20)
                .zIndex(5)
                .label(AALabel()
                    .text("PlotLines Element One")
                    .style(AAStyle(color: "#F05353"))),
             AAPlotLinesElement()
                .color("#33BDFD")
                .dashStyle(.longDashDot)
                .width(1)
                .value(40)
                .zIndex(5)
                .label(AALabel()
                    .text("PlotLines Element Two")
                    .style(AAStyle(color:"#33BDFD"))),
             AAPlotLinesElement()
                .color("#33BDFD")
                .dashStyle(.longDashDot)
                .width(1)
                .value(60)
                .zIndex(5)
                .label(AALabel()
                    .text("PlotLines Element Three")
                    .style(AAStyle(color:"#ADFF2F"))),
            ])
    }
    
    //MARK: -  柱状图
    private func customColumnrangeChartStyle() -> AAOptions {
        let aaChartModel = AAChartModel()
            .chartType(.columnrange)
            .inverted(true)
            .title("TEMPERATURE VARIATION BY MONTH")
            .subtitle("observed in Gotham city")
            .yAxisTitle("℃")
            .colorsTheme(["#fe117c","#06caf4",])//Colors theme
            .borderRadius(6)
            .categories([
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ])
            .series([
                AASeriesElement()
                    .name("temperature1")
                    .data([
                        [-9.7,  9.4],
                        [-8.7,  6.5],
                        [-3.5,  9.4],
                        [-1.4, 19.9],
                        [0.0,  22.6],
                        [2.9,  29.5],
                        [-9.7,  9.4],
                        [-8.7,  6.5],
                        [-3.5,  9.4],
                        [-1.4, 19.9],
                        [0.0,  22.6],
                        [2.9,  29.5],
                    ]),
//                AASeriesElement()
//                    .name("temperature2")
//                    .data([
//                        [9.2,  30.7],
//                        [7.3,  26.5],
//                        [4.4,  18.0],
//                        [-3.1, 11.4],
//                        [-5.2, 10.4],
//                        [-13.5, 9.8],
//                        [9.2,  30.7],
//                        [7.3,  26.5],
//                        [4.4,  18.0],
//                        [-3.1, 11.4],
//                        [-5.2, 10.4],
//                        [-13.5, 9.8]
//                    ]),
            ])
        
        let aaOptions = aaChartModel.aa_toAAOptions()
        
        //    *  关于 `pointPadding`
        //https://api.highcharts.com.cn/highcharts#plotOptions.column.groupPadding
        //
        //    * 关于 `pointPadding`
        //https://api.highcharts.com.cn/highcharts#plotOptions.column.pointPadding
        
        aaOptions.plotOptions?.columnrange?
            .grouping(false)
            .groupPadding(0.003)
        
        return aaOptions
    }
}


extension UserChartView: AAChartViewDelegate{
    func aaChartViewDidFinishLoad(_ aaChartView: AAChartView) {
        print("🚀🚀🚀🚀 AAChartView content did finish load!!!")
    }
    
    func aaChartViewDidFinishEvaluate(_ aaChartView: AAChartView) {
        
    }
    
    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        
    }
    
}
