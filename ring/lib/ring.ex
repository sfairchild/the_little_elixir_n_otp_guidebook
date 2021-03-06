defmodule Ring do
  def create_process(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop() end) end)
  end

  def loop() do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()
      :crash ->
        1/0
    end
  end

  def link_processes(procs) do
    link_processes(procs, [])
  end

  def link_processes([proc_1, proc_2 | rest], link_processes) do
    send(proc_1, {:link, proc_2})
    link_processes([proc_2 | rest], [proc_1 | link_processes])
  end

  def link_processes([proc|[]], link_processes) do
    first_process = link_processes |> List.last
    send(proc, {:link, first_process})
    :ok
  end

end
