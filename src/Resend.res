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
  type t =
    | Data(Data.t)
    | Error(Error.t)
    | Empty

  let decode: Json.Decode.t<t> = {
    open Json.Decode

    map2(
      field("data", Json.Decode.nullable(Data.decode)),
      field("error", Json.Decode.nullable(Error.decode)),
      ~f=(data, error) => {
        switch (data, error) {
        | (Some(data), _) => Data(data)
        | (_, Some(error)) => Error(error)
        | (None, None) => Empty
        }
      },
    )
  }
}

module Emails = {
  type t

  type textEmail = {
    from: string,
    to: string,
    subject: string,
    text: string,
  }

  type htmlEmail = {
    from: string,
    to: string,
    subject: string,
    html: string,
  }

  @send external sendText: (t, textEmail) => Promise.t<JSON.t> = "send"
  @send external sendHtml: (t, htmlEmail) => Promise.t<JSON.t> = "send"
}

type t = {emails: Emails.t}

@module("resend") @new external create: string => t = "Resend"
