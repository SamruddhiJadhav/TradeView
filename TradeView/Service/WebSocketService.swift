//
//  WebSocketService.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

protocol WebSocketService: AnyObject {
    func connectIfNeeded() async
    func send(_ message: String) async throws
    func messageStream() async -> AsyncThrowingStream<String, Error>
}
