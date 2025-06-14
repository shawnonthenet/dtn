defmodule Dtn.Tasks do
  use Ash.Domain,
    otp_app: :dtn,
    extensions: [AshPhoenix]

  resources do
    resource Dtn.Tasks.Task do
      define :list_tasks, action: :read
      define :create_task, action: :create
    end
  end
end
