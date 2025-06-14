defmodule Dtn.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Dtn.Accounts.User, _opts, _context) do
    Application.fetch_env(:dtn, :token_signing_secret)
  end
end
