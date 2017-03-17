defmodule Cache do
  use GenServer

  @name :cache_server

  def write(key, value) do
    GenServer.cast(@name, {:write, key, value})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.cast(@name, {:delete, key})
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def exist?(key) do
    GenServer.call(@name, {:exists?, key})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def handle_cast({:write, key, value}, state) do
    new_state = Map.put(state, key, value)
    {:noreply, new_state}
  end

  def handle_cast({:delete, key}, state) do
    new_state = Map.delete(state, key)
    {:noreply, new_state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end

  def handle_call({:read, key}, _from, state) do
    value = Map.fetch(state, key)
    {:reply, value, state}
  end

  def handle_call({:exists?, key}, _from, state) do
    exist = Map.has_key?(state, key)
    {:reply, exist, state}
  end
end
