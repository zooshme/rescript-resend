module Error = {
  type t = {
    statusCode: int,
    message: string,
    name: string,
  }

  let decode: Json.Decode.t<t> = {
    open Json.Decode

    map3(
      field("statusCode", int),
      field("message", string),
      field("name", string),
      ~f=statusCode => message => name => {statusCode, message, name},
    )
  }
}

module Data = {
  type t = {id: string}

  let decode: Json.Decode.t<t> = {
    open Json.Decode

    map(field("id", string), ~f=id => {id: id})
  }
}

module Response = {
  type t = {
    data: Data.t,
    error: Error.t,
  }

  let decode: Json.Decode.t<t> = {
    open Json.Decode

    map2(field("data", Data.decode), field("error", Error.decode), ~f=(data, error) => {
      data,
      error,
    })
  }
}

module Emails = {
  type t

  type email = {
    from: string,
    to: string,
    subject: string,
    text: string,
  }

  @send external send: (t, email) => Promise.t<Js.Json.t> = "send"
}

type t = {emails: Emails.t}

@module("resend") @new external create: string => t = "Resend"
