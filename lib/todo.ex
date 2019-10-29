defmodule Todo do
  @moduledoc """
  Documentation for Todo.
  """

  alias Todo.{Repo, Task}
  require Ecto.Query

  @format_string "~4ts~55ts~12ts~n"

  @doc """
  Hello world.

  ## Examples

      iex> Todo.hello
      :world

  """
  def add(message) do
    %Task{task: message} |> Repo.insert!()
    IO.puts("Added new item to do: #{message}")
  end

  def delete(id) do
    Repo.get!(Task, id) |> Repo.delete!()
    IO.puts("Deleted item with id: #{id}")
  end

  def show(all) do
    :io.fwrite(@format_string, ['id', 'task', 'status'])

    check = fn stuff ->
      unless all do
        Ecto.Query.where(stuff, completed: false)
      else
        stuff
      end
    end

    collection =
      Task
      |> check.()
      |> Repo.all()

    Enum.each(collection, &print_pretty(&1))
  end

  def toggle(id) do
    task = Repo.get!(Task, id)
    task = Ecto.Changeset.change(task, completed: !task.completed)
    struct = Repo.update!(task)

    IO.puts(
      "Updated task with id #{struct.id} to #{
        if struct.completed do
          'Done'
        else
          'Not Done'
        end
      }"
    )
  end

  defp print_pretty(%Task{id: id, task: task, completed: completed}) do
    :io.fwrite(@format_string, [
      Integer.to_string(id),
      task,
      if completed do
        'Done'
      else
        'Not Done'
      end
    ])
  end
end
