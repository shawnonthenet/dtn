defmodule Dtn.Tasks.Task do
  use Ash.Resource, otp_app: :dtn, domain: Dtn.Tasks, data_layer: AshPostgres.DataLayer

  postgres do
    table "tasks"
    repo Dtn.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:type, :block, :title, :message, :days, :printed]
    end

    update :update do
      accept [:type, :block, :title, :message, :days, :printed]
    end

    read :list_tasks_by_dow do
      argument :dow, :string
      argument :block, :string
      # we want to grab all unprinted tasks whenever we print
      filter expr(contains(days, ^arg(:dow)) || type == "task")
      filter expr(block == ^arg(:block) || type == "task")
      filter expr(printed == false)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :type, :string
    attribute :title, :string
    attribute :message, :string
    attribute :block, :string

    attribute :printed, :boolean do
      allow_nil? false
      default false
    end

    attribute :days, :string do
      allow_nil? false
    end

    timestamps()
  end
end
