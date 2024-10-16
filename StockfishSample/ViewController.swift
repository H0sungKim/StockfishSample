//
//  ViewController.swift
//  StockfishSample
//
//  Created by 김호성 on 2024.10.13.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var chessEngine = ChessEngine()
    private let sendFen = "r2q1rk1/1p2ppbp/3p2p1/p1pPn1B1/P1B1Q3/3P3P/1PP2PP1/R4RK1 b - - 0 13"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func onClick(_ sender: Any) {
        
        Task {
            await chessEngine.sendCommand("position fen \(sendFen);eval")
        }
        
    }
    private var cancellables = Set<AnyCancellable>()
}

class ChessEngine {
    private let stockfishWrapper = StockfishWrapper()
        
        
    init() {
        stockfishWrapper.startEngine()
        stockfishWrapper.onResponse = { [weak self] output in
            guard let self = self else { return }
            NSLog("\(output*100)")
        }
        sendInitCommand()
    }

    private func sendInitCommand() {
        Task {
            await sendCommand("uci")
            await sendCommand("isready")
        }
    }

    func sendCommand(_ command: String) async {
        stockfishWrapper.sendCommand(command)
    }

}
