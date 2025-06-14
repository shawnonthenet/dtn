defmodule Dtn.Accounts do
  use Ash.Domain,
    otp_app: :dtn

  resources do
    resource Dtn.Accounts.Token
    resource Dtn.Accounts.User
  end
end
