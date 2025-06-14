defmodule Dtn.Tasks.Printer do
  use Oban.Worker, queue: :default, max_attempts: 1

  alias Escpos.Printer
  alias Escpos.Commands

  @impl Oban.Worker
  def perform(_job) do
    print_tasks()
  end

  def print_tasks do
    tasks = Dtn.Tasks.list_tasks!() |> Enum.group_by(& &1.type)
    tasks = Map.merge(%{"task" => [], "exercise" => [], "chore" => []}, tasks)

    [path | _] = Path.wildcard("/dev/usb/lp*")
    {:ok, %Printer{} = printer} = Printer.from_path(path)
    tasks["task"] |> Enum.each(&print(printer, &1))
    tasks["exercise"] |> Enum.each(&print(printer, &1))
    tasks["chore"] |> Enum.each(&print(printer, &1))
    Printer.close(printer)
    :ok
  end


  def print(printer, task) do
    Escpos.write_image_file(printer, "priv/static/images/#{task.type}.png")

    Escpos.write(printer, Commands.TextFormat.txt_4square())
    Escpos.write(printer, "\n#{task.title}\n\n")
    Escpos.write(printer, Commands.TextFormat.txt_normal())
    Escpos.write(printer, "\n#{task.message}\n\n")
    Escpos.write(printer, Commands.Paper.full_cut())
  end
end
