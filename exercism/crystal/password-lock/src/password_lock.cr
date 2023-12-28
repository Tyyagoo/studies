class PasswordLock
  @password : (Int32 | String | Float64)
  def initialize(@password) end

  def _encrypt(pwd : (Int32 | String | Float64))
    if pwd.is_a?(Int32)
      (pwd / 2).round
    elsif pwd.is_a?(String)
      pwd.reverse
    else #pwd.is_a?(Float64)
      pwd * 4
    end
  end

  def encrypt
    @password = _encrypt(@password)
  end

  def unlock?(attempt)
    @password == _encrypt(attempt) ? "Unlocked" : nil
  end
end
