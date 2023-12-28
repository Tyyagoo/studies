class Matrix
  getter matrix : Array(Array(Int32))
  def initialize(content : String)
    @matrix = content.split("\n").map { |x| x.split(" ").map(&.to_i32) }
  end

  def row(idx : Int32)
    @matrix[idx - 1]
  end

  def column(idx : Int32)
    @matrix.flat_map { |xs| xs[idx - 1] }
  end
end
