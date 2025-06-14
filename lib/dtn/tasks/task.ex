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
      accept [:type, :title, :message, :days]
    end

    update :update do
      accept [:type, :title, :message, :days]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :type, :string
    attribute :title, :string
    attribute :message, :string

    attribute :days, :string do
      allow_nil? false
    end

    timestamps()
  end
end
