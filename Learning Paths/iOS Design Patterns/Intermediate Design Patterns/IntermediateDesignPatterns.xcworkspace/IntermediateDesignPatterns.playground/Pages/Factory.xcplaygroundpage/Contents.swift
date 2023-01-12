/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Factory
 - - - - - - - - - -
 ![Factory Diagram](Factory_Diagram.png)
 
 The factory pattern provides a way to create objects without exposing creation logic. It involves two types:
 
 1. The **factory** creates objects.
 2. The **products** are the objects that are created.
 
 ## Code Example
 */

import Foundation

public struct JobApplicant {
  public enum Status {
    case new
    case interview
    case hired
    case rejected
  }

  public let name: String
  public let email: String
  public let yearsOfExperience: Int
  public var status: Status
}

public struct Email {
  public let subject: String
  public let body: String
  public let recipientEmail: String
  public let senderEmail: String
}

public struct EmailFactory {
  public let senderEmail: String

  public func createEmail(to recipient: JobApplicant) -> Email {
    let subject: String
    let body: String
    switch recipient.status {
    case .new:
      subject = "We received your application"
      body = "We will review your application and get back to you."
    case .interview:
      subject = "We would like to schedule an interview"
      body = "We would like to schedule an interview for you. Please let us know what times work best for you."
    case .hired:
      subject = "We would like to offer you a position"
      body = "We would like to offer you a position. Please let us know if you accept."
    case .rejected:
      subject = "We have decided to move forward with another candidate"
      body = "We have decided to move forward with another candidate. Thank you for your time."
    }

    return Email(subject: subject, body: body, recipientEmail: recipient.email, senderEmail: senderEmail)
  }
}

// Example
var applicant = JobApplicant(name: "John Appleseed", email: "john.appleseed@apple.com", yearsOfExperience: 5, status: .new)
let emailFactory = EmailFactory(senderEmail: "jobs@kodeco.com")
print(emailFactory.createEmail(to: applicant))

applicant.status = .interview
print(emailFactory.createEmail(to: applicant))

applicant.status = .hired
print(emailFactory.createEmail(to: applicant))
