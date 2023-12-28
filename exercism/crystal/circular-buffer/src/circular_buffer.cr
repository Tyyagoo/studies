class CircularBuffer
  @write_idx = 0
  @read_idx = 0
  def initialize(@len : Int32); @b = Array(Int32?).new(@len, nil); end

  def read
    maybe_int = @b[@read_idx]
    raise RuntimeError.new("Buffer is empty.") if maybe_int.nil?
    @b[@read_idx] = nil
    @read_idx = _next_idx(@read_idx)
    maybe_int
  end

  def clear
    @write_idx = @read_idx = 0
    @b.map! { nil }
  end

  def write(val)
    _write(val, -> { raise RuntimeError.new("Buffer is full.") })
  end

  def overwrite(val)
    _write(val, -> { @read_idx = _next_idx(@read_idx) })
  end

  private def _write(val, on_error : -> _)
    on_error.call unless @b[@write_idx].nil?
    @b[@write_idx] = val
    @write_idx = _next_idx(@write_idx)
  end

  private def _next_idx(idx); idx + 1 >= @len ? 0 : idx + 1; end
end
