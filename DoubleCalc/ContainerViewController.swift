//
//  ContainerViewController.swift
//  DoubleCalc
//
//  Created by yuhua Tang on 2023/12/1.
//

import UIKit

//
// @nonobjc extension UIViewController {
//    func add(_ child: UIViewController, frame: CGRect? = nil) {
//        addChild(child)
//
//        if let frame = frame {
//            child.view.frame = frame
//        }
//
//        view.addSubview(child.view)
//        child.didMove(toParent: self)
//    }
//
//    func remove() {
//        willMove(toParent: nil)
//        view.removeFromSuperview()
//        removeFromParent()
//    }
// }
import SnapKit

class ContainerViewController: UIViewController {
    lazy var leftCalcVC: CalcViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "calculator") as? CalcViewController else {
            return CalcViewController()
        }
        return vc
    }()

    lazy var rightCalcVC: CalcViewController =  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "calculator") as? CalcViewController else {
            return CalcViewController()
        }
        return vc
    }()

    @IBOutlet weak var leftView: UIView!

    @IBOutlet weak var rightView: UIView!

    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(leftCalcVC)
        leftView.addSubview(leftCalcVC.view)
        leftCalcVC.view.snp.makeConstraints { make in
            make.edges.equalTo(leftView)
        }

        leftCalcVC.didMove(toParent: self)

        addChild(rightCalcVC)
        rightView.addSubview(rightCalcVC.view)
        rightCalcVC.view.snp.makeConstraints { make in
            make.edges.equalTo(rightView)
        }
        rightCalcVC.didMove(toParent: self)

    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

    }

}
