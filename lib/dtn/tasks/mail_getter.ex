defmodule Dtn.Tasks.MailGetter do
  use Oban.Worker, queue: :default, max_attempts: 3

  alias Escpos.Printer

  @impl Oban.Worker
  def perform(_job) do
    get_mail()
  end

  def get_mail do

    [path | _] = Path.wildcard("/dev/usb/lp*")
    {:ok, %Printer{} = printer} = Printer.from_path(path)
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

        {:ok, task} = Dtn.Tasks.create_task(%{
          "title" => parsed_message.headers["subject"],
          "message" => inline_message.body,
          "days" => "1",
          "type" => "task",
          "block" => "am",
          "printed" => true
        })
        Dtn.Tasks.Printer.print(printer, task)
        :ok = Mailroom.POP3.delete(client, mail)
      end)
      :ok = Mailroom.POP3.close(client)
      Printer.close(printer)
  end
end
