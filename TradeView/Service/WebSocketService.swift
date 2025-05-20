//
//  WebSocketService.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

protocol WebSocketService: AnyObject {
    func connect() async
    func send(_ message: String) async throws
    func disconnect() async
    func messageStream() async -> AsyncThrowingStream<String, Error>
}
