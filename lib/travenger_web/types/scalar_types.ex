defmodule TravengerWeb.ScalarTypes do
  @moduledoc """
  GraphQL scalar types
  """

  use Absinthe.Schema.Notation
  alias Calendar.ISO

  scalar :naive_datetime do
    description("ISOz time")

    serialize(
      &ISO.naive_datetime_to_string(
        &1.year,
        &1.month,
        &1.day,
        &1.hour,
        &1.minute,
        &1.second,
        &1.microsecond
      )
    )
  end
end
