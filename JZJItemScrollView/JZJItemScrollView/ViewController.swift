//
//  ViewController.swift
//  JZJItemScrollView
//
//  Created by 易骆驼 on 2017/8/23.
//  Copyright © 2017年 eluotuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let scrollview = JZJItemScrollView(frame: CGRect(x: 0, y: 50, width: 320, height: 40), titles: ["作品信息","作品评论"], selectedColor: UIColor.blue, normalColor: .black, underlineHeight: 1.5)
        scrollview.setDefaultSelectedItem(index: 1)
        scrollview.setSeperatorLineView(color: .red, lineWidth: 1, lineHeight: 20)
        scrollview.delegate = self
        view.addSubview(scrollview)
    }
}
extension ViewController : JZJItemScrollViewDelegate {
    func itemScrollView(_ itemScorllView: JZJItemScrollView, didSelectedItemAt index: NSInteger) {
        print(index)
    }
}
