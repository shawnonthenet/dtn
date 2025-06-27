defmodule Dtn.Tasks.Printer do
  use Oban.Worker, queue: :default, max_attempts: 1

  alias Escpos.Printer
  alias Escpos.Commands

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"block" => block}}) do
    dow =
      DateTime.utc_now()
      |> DateTime.shift_zone!("Australia/Sydney")
      |> DateTime.to_date()
      |> Date.day_of_week()

    print_tasks("#{dow}", block)
  end

  def print_tasks(dow, block) do
    tasks = Dtn.Tasks.list_tasks_by_dow!(dow, block) |> Enum.group_by(& &1.type)
    tasks = Map.merge(%{"task" => [], "exercise" => [], "chore" => []}, tasks)

    [path | _] = Path.wildcard("/dev/usb/lp*")
    {:ok, %Printer{} = printer} = Printer.from_path(path)
    tasks["task"] |> Enum.each(&print(printer, &1))
    tasks["exercise"] |> Enum.each(&print(printer, &1))
    tasks["chore"] |> Enum.each(&print(printer, &1))

    # Mark tasks as printed so we don't ever repeat them
    Enum.each(tasks["task"], fn t ->
      Dtn.Tasks.update_task!(t, %{printed: true})
    end)

    Printer.close(printer)
    :ok
  end

  def print(printer, task) do
    Escpos.write(printer, "\n#{task.title}\n")
    Escpos.write(printer, Commands.lf())
    Escpos.write(printer, Commands.lf())
    Escpos.write(printer, Commands.TextFormat.txt_4square())
    Escpos.write(printer, "\n#{task.message}\n\n\n\n")
    Escpos.write(printer, Commands.lf())
    Escpos.write(printer, Commands.lf())
    Escpos.write(printer, Commands.Paper.full_cut())
  end
end
