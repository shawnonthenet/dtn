defmodule Dtn.Repo.Migrations.AddBlockToTasks do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:tasks) do
      add :block, :text
    end
  end

  def down do
    alter table(:tasks) do
      remove :block
    end
  end
end
