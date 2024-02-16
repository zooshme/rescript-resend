type t

@module("resend") @new external create: string => t = "Resend"

module Emails = {
  type t

  type email = {
    from: string,
    to: string,
    subject: string,
    text: string,
  }

  @send external send: (t, email) => Promise.t<unit> = "send"
}

@set external emails: t => Emails.t = "emails"
