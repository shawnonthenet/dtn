defmodule Dtn.Tasks do
  use Ash.Domain,
    otp_app: :dtn,
    extensions: [AshPhoenix]

  resources do
    resource Dtn.Tasks.Task do
      define :get_task, action: :read, get_by: :id
      define :list_tasks, action: :read
      define :create_task, action: :create
      define :update_task, action: :update
      define :delete_task, action: :destroy
      define :list_tasks_by_dow, action: :list_tasks_by_dow, args: [:dow, :block]
    end
  end
end
