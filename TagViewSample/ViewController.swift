//
//  ViewController.swift
//  TagViewSample
//
//  Created by JaN on 2017/7/5.
//  Copyright © 2017年 givingjan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var m_tagViewSingle: SMTagView!
    @IBOutlet var m_tagViewMultiple: SMTagView!
    @IBOutlet var m_btnChange: UIButton!
    
    var m_bIsMultiple : Bool = true
    var tags : [String] = ["咖啡Q","聰明奶茶","笑笑乒乓","下雨天的紅茶","明天的綠茶","笨豆漿","過期的茶葉蛋","雲端奶茶","國際的小鳳梨","黑胡椒樹皮"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:Init 
    private func initMultiple() {
        self.m_tagViewMultiple.layer.cornerRadius = 15.0
        self.m_tagViewMultiple.tagMainColor = UIColor.orange
        self.m_tagViewMultiple.setTagForMultiple(title: "選幾個喜歡的吧 ! (多選)", tagType: .fill, tags: tags, maximumSelect: 3, minimumSelect: 2) { (indexes) in
            print("done:\(indexes)")
        }
    }
    
    private func initSingle() {
        self.m_tagViewSingle.layer.cornerRadius = 15.0
        self.m_tagViewSingle.tagMainColor = UIColor.orange
        self.m_tagViewSingle.setTagForSingle(title: "你要選哪個呢 ? (單選)", tagType: .border, tags: tags)  { (index) in
            print(index)
        }
    }
    
    private func initView() {
        initMultiple()
        initSingle()
        
        updateView()
    }
        
    private func updateView() {
        self.m_tagViewSingle.isHidden = self.m_bIsMultiple
        self.m_tagViewMultiple.isHidden = !self.m_bIsMultiple
    }

    @IBAction func handleChange(_ sender: Any) {
        self.m_bIsMultiple = !self.m_bIsMultiple
        
        let title = self.m_bIsMultiple == true ? "Change to Single" : "Change to Multiple"
        self.m_btnChange.setTitle(title, for: .normal)
        
        self.updateView()
    }
}

