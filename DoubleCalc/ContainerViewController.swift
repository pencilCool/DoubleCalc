//
//  ContainerViewController.swift
//  DoubleCalc
//
//  Created by yuhua Tang on 2023/12/1.
//

import UIKit

import SnapKit

class ContainerViewController: UIViewController {
    static func calcVC() -> CalcViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "calculator") as? CalcViewController else {
            return CalcViewController()
        }

        return vc
    }

    lazy var leftCalcVC: CalcViewController = {
        let vc = ContainerViewController.calcVC()
        vc.delegate = self
        return vc
    }()

    lazy var rightCalcVC: CalcViewController =  {
        let vc = ContainerViewController.calcVC()
        vc.delegate = self
        return vc
    }()

    var currentActiveVC: CalcViewController?

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

    @IBAction func setResultToLeft(_ sender: Any) {
        self.currentActiveVC = self.leftCalcVC
        self.rightCalcVC.calculate()
        self.leftCalcVC.inputResult(self.rightCalcVC.currentResult)
    }

    @IBAction func setResultToRight(_ sender: Any) {
        self.currentActiveVC = self.rightCalcVC
        self.leftCalcVC.calculate()
        self.rightCalcVC.inputResult(self.leftCalcVC.currentResult)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.currentActiveVC?.delete()
    }

}

extension  ContainerViewController: CalcViewControllerDelegate {
    func currentActive(_ vc: CalcViewController) {
        self.currentActiveVC = vc
    }
}
