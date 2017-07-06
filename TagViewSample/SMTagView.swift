//
//  SMTagView.swift
//  TagViewSample
//
//  Created by JaN on 2017/7/5.
//  Copyright © 2017年 givingjan. All rights reserved.
//

import UIKit
enum SMTagType : Int {
    case fill = 0
    case border = 1
}

class SMTagView: UIView {

    private let kMargin : CGFloat = 12.0
    private let kPadding : CGFloat = 6.0
    private let kHeaderHeight : CGFloat = 64.0
    // ResultButton
    private let kResultButtonHeight : CGFloat = 54.0
    
    private let kButtonHeight : CGFloat = 44.0
    private let kBorderColor : UIColor = UIColor.lightGray
    
    // MARK: Member Variables
    // User Setting
    var titleColor : UIColor = UIColor.darkGray
    var titleFont : UIFont = UIFont.systemFont(ofSize: 20.0)
    
    var tagTextColor : UIColor = UIColor.lightGray
    var tagCornerRadius : CGFloat = 20.0
    var tagMainColor : UIColor = UIColor.orange
    
    var doneButtonTitleColor : UIColor = UIColor.white
    var doneButtonBackgroundColor : UIColor = UIColor.orange
    var doneButtonTitle : String = "Done"
    var doneButtonCornerRadius : CGFloat = 8.0
    
    // Private Variables
    private var m_bIsMultipleSelect : Bool!
    private var m_iMaximumSelect : Int?
    private var m_iMinimumSelect : Int?
    private var m_arySelectedIndexes : [Int] = []
    private var m_aryTags : [String] = []
    private var m_aryBtns : [UIButton] = []
    private var m_tagType : SMTagType!
    private var m_titleTextAliment : NSTextAlignment = NSTextAlignment.left
    private var m_scrollView : UIScrollView!
    
    private var didSelectedForSingle : ((_ selectedIndex : Int)->())?
    private var didSelectedForMultiple : ((_ selctedIndexes : [Int])->())?
    
    private var m_doneButton : UIButton!
    
    // MARK: Life Cycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: UI Methods
    private func initScrollForMultiple() {
        self.m_bIsMultipleSelect = true
        self.m_scrollView = UIScrollView(frame: CGRect(x: 0, y: kHeaderHeight + kMargin, width: self.frame.width, height: self.frame.height - kResultButtonHeight - kMargin*2 - kHeaderHeight - kMargin))
        self.m_scrollView.isScrollEnabled = true
        
        self.addSubview(self.m_scrollView)
        
        self.addDoneButton()
    }

    private func initScrollForSingle() {
        self.m_bIsMultipleSelect = false
        self.m_scrollView = UIScrollView(frame: CGRect(x: 0, y: kHeaderHeight + kMargin, width: self.frame.width, height: self.frame.height - kHeaderHeight - kMargin))
        self.m_scrollView.isScrollEnabled = true
        
        self.addSubview(self.m_scrollView)
    }

    private func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    private func configureTitle(title : String) {
        let titleLabel : UILabel = UILabel(frame: CGRect(x: kMargin, y: kMargin, width: self.frame.size.width - kMargin*2, height: kHeaderHeight))
        
        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = self.m_titleTextAliment
        titleLabel.font = titleFont
        
        self.addSubview(titleLabel)
    }
    
    private func configureTags() {
        self.m_aryBtns = []
        
        var xPosition : CGFloat = kMargin
        var yPosition : CGFloat = kMargin
        
        for (index,title) in self.m_aryTags.enumerated() {
            let btn : UIButton = getButton(text: title, index: index)
            btn.sizeToFit()
            
            self.m_aryBtns.append(btn)
        }
        
        
        for (index,btn) in self.m_aryBtns.enumerated() {
            
            let width = btn.frame.size.width + 20
            let nextBtnWidth = index >= self.m_aryBtns.count-1 ? 0 : self.m_aryBtns[index+1].frame.size.width
            
            btn.frame = CGRect(x: xPosition, y: yPosition, width: width, height: kButtonHeight)

            xPosition = xPosition + width + nextBtnWidth + kPadding*2 > (self.m_scrollView.frame.width - kMargin) ? kMargin : xPosition + width + kPadding
            yPosition = xPosition > kMargin ? yPosition : yPosition + kButtonHeight + kPadding
            
            
            self.m_scrollView.addSubview(btn)
        }
        
        self.m_scrollView.contentSize = CGSize(width: 1, height: yPosition + kButtonHeight)
    }
    
    private func getButton(text : String, index : Int) -> UIButton {
        let btn : UIButton = UIButton(type: .custom)
        
        btn.layer.cornerRadius = tagCornerRadius
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = kBorderColor.cgColor
        btn.setTitle(text, for: .normal)
        btn.tag = index
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(SMTagView.handleSelected(_:)), for: .touchUpInside)
        btn.setBackgroundImage(from(color: UIColor.white), for: .normal)
        btn.setTitleColor(tagTextColor, for: .normal)
        
        switch self.m_tagType! {
        case .fill:
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.setBackgroundImage(from(color: self.tagMainColor), for: .selected)
        case .border:
            btn.setTitleColor(self.tagMainColor, for: .selected)
        }
        
        return btn
    }
    
    private func addDoneButton() {
        let btnDone : UIButton = UIButton(frame: CGRect(x: kMargin, y: self.m_scrollView.frame.origin.y + self.m_scrollView.frame.height + kMargin, width: self.frame.width - kMargin*2, height: kResultButtonHeight))
        btnDone.setTitle(self.doneButtonTitle, for: .normal)
        btnDone.setTitleColor(self.doneButtonTitleColor, for: .normal)
        btnDone.setBackgroundImage(from(color: self.doneButtonBackgroundColor), for: .normal)
        btnDone.layer.cornerRadius = self.doneButtonCornerRadius
        btnDone.addTarget(self, action: #selector(SMTagView.handleDone(_ :)), for: .touchUpInside)
        btnDone.layer.masksToBounds = true
        
        if self.m_iMinimumSelect != nil && self.m_iMinimumSelect! > 0{
            btnDone.isEnabled = false
        }
        self.m_doneButton = btnDone
        self.addSubview(btnDone)
    }
    
    private func updateSelectedIndexes() {
        self.m_arySelectedIndexes = []
        
        for btn in self.m_aryBtns {
            if btn.isSelected == true {
                self.m_arySelectedIndexes.append(btn.tag)
            }
        }
        
        print("\(self.m_arySelectedIndexes)")
    }
    
    private func checkIsMaximum() -> Bool {
        if self.m_iMaximumSelect == nil {
            
        }
        var count = 0
        
        for btn in self.m_aryBtns {
            if btn.isSelected == true {
                count += 1
            }
        }
        
        if count >= self.m_iMaximumSelect! {
            return true
        } else {
            return false
        }
    }
    
    private func unselectedAllButtons() {
        for btn in self.m_aryBtns {
            btn.isSelected = false
            btn.layer.borderColor = kBorderColor.cgColor
        }
    }
    // MARK: Handle Action
    @objc func handleDone(_ btn : UIButton) {
        if self.didSelectedForMultiple != nil {
            self.didSelectedForMultiple!(self.m_arySelectedIndexes)
        }
    }
    @objc func handleSelected(_ btn : UIButton) {
        if self.m_bIsMultipleSelect == true {
            if self.m_iMaximumSelect != nil && self.m_iMaximumSelect! <= self.m_arySelectedIndexes.count && btn.isSelected == false {
                return
            }
            
            btn.isSelected = !btn.isSelected
        } else {
            unselectedAllButtons()
            btn.isSelected = !btn.isSelected
        }
        
        if btn.isSelected == true {
            btn.layer.borderColor = self.tagMainColor.cgColor
        } else {
            btn.layer.borderColor = kBorderColor.cgColor
        }
        
        if self.m_bIsMultipleSelect == true {
            self.updateSelectedIndexes()
            
            if self.m_iMinimumSelect != nil {
                if self.m_arySelectedIndexes.count >= self.m_iMinimumSelect! {
                    self.m_doneButton.isEnabled = true
                } else {
                    self.m_doneButton.isEnabled = false
                }
            }
            
        } else {
            if self.didSelectedForSingle != nil {
                self.didSelectedForSingle!(btn.tag)
            }
        }
    }
    
    // MARK: Public Methods
    func sortTags() {
        
    }
    
    
    func setTagForMultiple(title : String, tagType : SMTagType, tags : [String], maximumSelect : Int?, minimumSelect : Int?, didSelected : (([Int])->())?) {
        if maximumSelect != nil {
            self.m_iMaximumSelect = maximumSelect!
        }
        if minimumSelect != nil {
            self.m_iMinimumSelect = minimumSelect!
        }
        
        if didSelected != nil {
            self.didSelectedForMultiple = didSelected!
        }
        
        self.m_aryTags = tags
        self.m_tagType = tagType
        
        self.initScrollForMultiple()
        self.configureTitle(title: title)
        self.configureTags()
    }
    
    func setTagForSingle(title : String, tagType : SMTagType, tags : [String], didSelected : ((Int)->())?) {
        self.m_aryTags = tags
        self.m_tagType = tagType
        
        if didSelected != nil {
            self.didSelectedForSingle = didSelected!
        }
        
        
        self.initScrollForSingle()
        self.configureTitle(title: title)
        self.configureTags()
    }

}
