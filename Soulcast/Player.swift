

import Foundation
import AudioKit

protocol PlayerSubscriber {
  func playerStarted()
  func playerFinished(_ url: URL)
  func playerFailed()
  var hashValue: Int { get }
}

class Player {
  static var playing = false
  static var subscribers: [PlayerSubscriber] = []
  static func play(url:URL, subscriber:PlayerSubscriber? = nil) {
    subscribe(subscriber)
    _ = subscribers.map{$0.playerStarted()}
    AudioKit.start()
    do {
      playing = true
      let file = try AKAudioFile(forReading: url)
      if let player = file.player {
        AudioKit.output = player
        player.play()
        player.completionHandler = {
          _ = subscribers.map{$0.playerFinished(url)}
          unsubscribe(subscriber)
          playing = false
        }
      }
    } catch {
      _ = subscribers.map{$0.playerFailed()}
      unsubscribe(subscriber)
    }
  }
  static func stop() {
    //TODO:
  }
  
  fileprivate static func subscribe(_ subber:PlayerSubscriber?) {
    guard let subber = subber else { return }
    if !subscribers.contains{$0.hashValue == subber.hashValue} {
      subscribers.append(subber)
    }
  }
  
  fileprivate static func unsubscribe(_ subber: PlayerSubscriber?) {
    guard let subber = subber else { return }
    if let index = subscribers.index(where:{$0.hashValue == subber.hashValue}) {
      subscribers.remove(at: index)
    }
  }
  
}
