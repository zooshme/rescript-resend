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

type t = {emails: Emails.t}

@module("resend") @new external create: string => t = "Resend"
