//
//  ViewController.swift
//  scroll
//
//  Created by Sasha Myshkina on 01.05.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    private var bottomConstraint: NSLayoutConstraint!
    
    private var contentOpenedCount = 0 {
        didSet {
            if contentOpenedCount == 2 {
                self.button.setTitle("Finish", for: UIControl.State.normal)
            }
        }
    }

    private let button: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setTitle("Next", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.textColor = .black
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b.layer.cornerRadius = 21.5
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()

    private let firstView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let secondView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let thirdView: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .cyan
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("screenHeight:",screenHeight)
        scrollView.delegate = self
        configureScrollView()
        configureFirstPage()

        
    }

    
    @objc fileprivate func buttonPressed() {
        if contentOpenedCount == 0 {
            configureSecondPage()
            contentOpenedCount += 1
            let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in
                self.scrollView.scrollToView(view: self.secondView, animated: true)
            }
            
        } else if contentOpenedCount == 1 {
            configureThirdPage()
            contentOpenedCount += 1
            
            let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (t) in
                self.scrollView.scrollToView(view: self.thirdView, animated: true)
            }
        }
    }
    
    
    
    fileprivate func configureScrollView() {
        self.view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

    }
    
    
    fileprivate func configureButton(b: UIButton) {
        b.bottomAnchor.constraint(equalTo: b.superview!.bottomAnchor, constant: -40).isActive = true
        b.widthAnchor.constraint(equalToConstant: 170).isActive = true
        b.heightAnchor.constraint(equalToConstant: 43).isActive = true
        b.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    fileprivate func configureFirstPage() {
        scrollView.addSubview(firstView)
        firstView.addSubview(button)
        NSLayoutConstraint.activate([
            firstView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            firstView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            firstView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            firstView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            firstView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        configureButton(b: button)
        
        
    }
    
    fileprivate func configureSecondPage() {
        scrollView.addSubview(secondView)
        bottomConstraint = secondView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            secondView.heightAnchor.constraint(equalToConstant: screenHeight),
            secondView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            secondView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 0),
            bottomConstraint
            ])
        secondView.addSubview(button)
        configureButton(b: button)

    }
    
    
    fileprivate func configureThirdPage() {
        bottomConstraint.isActive = false
        scrollView.addSubview(thirdView)
        NSLayoutConstraint.activate([
            thirdView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            thirdView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            thirdView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            thirdView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            thirdView.topAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 0),
            thirdView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
            ])
        
        thirdView.addSubview(button)
        configureButton(b: button)
    }
    
}



extension UIScrollView {
    

    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
