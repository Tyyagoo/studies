defmodule Zipper do
  defstruct [:focus, :parent, :dir]

  alias BinTree, as: BT

  @type dir :: :left | :right | nil
  @type t :: %Zipper{focus: %BT{}, parent: t() | nil, dir: dir()}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{focus: bin_tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BT.t()
  def to_tree(%Zipper{focus: root, parent: nil, dir: nil}), do: root
  def to_tree(zipper), do: zipper |> up |> to_tree

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper), do: zipper.focus.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper) do
    case zipper.focus do
      %BT{left: nil} -> nil
      %BT{left: left} -> %Zipper{focus: left, parent: zipper, dir: :left}
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper) do
    case zipper.focus do
      %BT{right: nil} -> nil
      %BT{right: right} -> %Zipper{focus: right, parent: zipper, dir: :right}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{parent: nil}), do: nil

  def up(%Zipper{focus: focus, parent: parent, dir: dir}) do
    updated_tree =
      case dir do
        :left -> %BT{parent.focus | left: focus}
        :right -> %BT{parent.focus | right: focus}
      end

    %Zipper{parent | focus: updated_tree}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %Zipper{zipper | focus: %BT{zipper.focus | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BT.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | focus: %BT{zipper.focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BT.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | focus: %BT{zipper.focus | right: right}}
  end
end