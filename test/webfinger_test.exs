defmodule WebfingerTest do
  use ExUnit.Case
  doctest Webfinger

  import Webfinger

  test "non-https url" do
    {atom, reason} = Webfinger.lookup("http://invalidurl")
    assert atom == :error
  end
end
