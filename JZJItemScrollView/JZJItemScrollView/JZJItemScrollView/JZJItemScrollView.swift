//
//  JZJItemScrollView.swift
//  JZJItemScrollView
//
//  Created by 易骆驼 on 2017/8/23.
//  Copyright © 2017年 eluotuo. All rights reserved.
//

import UIKit

@objc public  protocol JZJItemScrollViewDelegate {
    func itemScrollView(_ itemScorllView : JZJItemScrollView, didSelectedItemAt index:NSInteger)
}

public class JZJItemScrollView: UIView {

    fileprivate lazy var scrollView = UIScrollView()
    fileprivate lazy var allBtns = [UIButton]()
    fileprivate lazy var lineView = UIView()
    ///代理
   public var delegate : JZJItemScrollViewDelegate?
    
    
    /// 设置默认选中项
    ///
    /// - Parameter index: 默认选中项索引
   public func setDefaultSelectedItem(index : Int) {
        
        let firstBtn = allBtns.first
        firstBtn?.isSelected = false
        
        if index >= allBtns.count {
            return
        }
        let btn = allBtns[index]
        btn.isSelected = true
        lineView.frame = generateFrameForLineView(btn: btn)
    }
    
    
    
    
    
    /// 根据指定参数生成实例对象
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标题数组
    ///   - selectedColor: 选中状态文本颜色
    ///   - hasSeperatorLine: 是否显示分割线
    ///   - normalColor: 普通状态文本颜色 默认为黑色
   public init(frame: CGRect, titles : [String], selectedColor : UIColor,hasSeperatorLine : Bool = false, normalColor : UIColor = UIColor.black) {
        
        super.init(frame: frame)
        
        setupUI(titles: titles, selectedColor: selectedColor, normalColor: normalColor, hasSeperatorLine: hasSeperatorLine)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//MARK: - 私有方法
private extension JZJItemScrollView {
    //MARK: - 监听方法
    @objc func btnClicked(sender : UIButton) {
        
        for btn in allBtns {
            btn.isSelected = false
        }
        sender.isSelected = true
        ///执行下划线动画
        underlineAnimation(btn : sender)
        
        delegate?.itemScrollView(self, didSelectedItemAt: sender.tag)
    }
    
    //MARK: - 下划线动画
    func underlineAnimation(btn : UIButton){
        
        UIView.animate(withDuration: 0.2) {
            self.lineView.frame = self.generateFrameForLineView(btn: btn)
        }
        
    }
    //MARK: - 计算下划线的frame
    func generateFrameForLineView(btn : UIButton) -> CGRect {
        guard let title = btn.titleLabel?.text else {
            return CGRect()
        }
        let size = (title as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: 1000.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15)], context: nil).size
        let lineWidth = size.width + 10
        let x = btn.center.x - lineWidth / 2
        return  CGRect(x: x, y: self.frame.height - 1, width: lineWidth, height: 1)
    }

}

private extension JZJItemScrollView{
    func setupUI(titles : [String], selectedColor : UIColor, normalColor : UIColor = UIColor.black, hasSeperatorLine : Bool = false){
        
        backgroundColor = UIColor.white
        //1.设置滚动视图
        scrollView.frame = bounds
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
//        scrollView.delegate = self
        self.addSubview(scrollView)
    
        let kMaxItems = 5
        
        var count = titles.count
        if titles.count >= kMaxItems {
            count = 5
        }
        let btnWidth = frame.width / CGFloat(count)
        
        for (i ,title) in titles.enumerated() {
            
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(normalColor, for: .normal)
            btn.setTitleColor(selectedColor, for: .selected)
            btn.frame = CGRect(x: CGFloat(i)*btnWidth, y: 0, width: btnWidth, height: frame.height)
            lineView.backgroundColor = selectedColor
             //设置下划线视图
            if i == 0 {
                btn.isSelected = true
                
                lineView.frame = generateFrameForLineView(btn: btn)
                
                scrollView.addSubview(lineView)
            }
            
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            allBtns.append(btn)
            
            scrollView.addSubview(btn)
            
            if hasSeperatorLine && i != titles.count {
                let x = CGFloat(i+1) * btnWidth
                let seperatorLineView = UIView(frame: CGRect(x: x, y: 5, width: 1, height: frame.height - 10))
                seperatorLineView.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                scrollView.addSubview(seperatorLineView)
                
                
            }
            
        }
        scrollView.contentSize = CGSize(width: CGFloat(titles.count)*btnWidth, height: frame.height)
        
    }
}
