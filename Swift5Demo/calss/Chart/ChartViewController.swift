//
//  ChartViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/9/21.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let chart = UserChartView()
        view.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
