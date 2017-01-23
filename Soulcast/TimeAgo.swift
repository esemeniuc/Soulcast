
import Foundation

public func timeAgo(epoch:Int) -> String{
  let interval = TimeInterval(epoch)
  let date = Date(timeIntervalSince1970: interval)
  return timeAgoSince(date)
}

public func timeAgoSince(_ date: Date) -> String {
  
  let calendar = Calendar.current
  let now = Date()
  let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
  let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
  
  if components.year! >= 2 {
    return "\(components.year!) years ago"
  }
  
  if components.year! >= 1 {
    return "Last year"
  }
  
  if components.month! >= 2 {
    return "\(components.month!) months ago"
  }
  
  if components.month! >= 1 {
    return "Last month"
  }
  
  if components.weekOfYear! >= 2 {
    return "\(components.weekOfYear!) weeks ago"
  }
  
  if components.weekOfYear! >= 1 {
    return "Last week"
  }
  
  if components.day! >= 2 {
    return "\(components.day!) days ago"
  }
  
  if components.day! >= 1 {
    return "Yesterday"
  }
  
  if components.hour! >= 2 {
    return "\(components.hour!) hours ago"
  }
  
  if components.hour! >= 1 {
    return "An hour ago"
  }
  
  if components.minute! >= 2 {
    return "\(components.minute!) minutes ago"
  }
  
  if components.minute! >= 1 {
    return "A minute ago"
  }
  
  if components.second! >= 3 {
    return "\(components.second!) seconds ago"
  }
  
  return "Just now"
  
}
