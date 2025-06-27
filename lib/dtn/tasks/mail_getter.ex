defmodule Dtn.Tasks.MailGetter do
  use Oban.Worker, queue: :mail_getter, max_attempts: 3

  @impl Oban.Worker
  def perform(_job) do
    get_mail()
  end

  def get_mail do

    {:ok, client} =
      Mailroom.POP3.connect(
        Application.get_env(:dtn, :mail_getter)[:pop3_host],
        Application.get_env(:dtn, :mail_getter)[:pop3_username],
        Application.get_env(:dtn, :mail_getter)[:pop3_password],
        ssl: true,
        ssl_opts: [verify: :verify_none]
      )
      client
      |> Mailroom.POP3.list()
      |> Enum.each(fn(mail) ->
        {:ok, message} = Mailroom.POP3.retrieve(client, mail)
        parsed_message = Mail.parse(message)
        inline_message = parsed_message.parts |> Enum.find(fn(part) -> part.headers["content-disposition"] == "inline" end)

        Dtn.Tasks.create_task(%{
          "title" => parsed_message.headers["subject"],
          "message" => inline_message.body,
          "days" => "1",
          "type" => "task",
          "block" => "am"
        })
        :ok = Mailroom.POP3.delete(client, mail)
      end)
      :ok = Mailroom.POP3.close(client)
  end
end
