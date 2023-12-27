class HighSchoolSweetheart
  def self.clean_up_name(name)
    name.gsub("-", " ").strip
  end

  def self.first_letter(name)
    self.clean_up_name(name)[0]
  end

  def self.initial(name)
    self.first_letter(name).upcase + "."
  end

  def self.pair(name1, name2)
    "❤ #{self.initial(name1)}  +  #{self.initial(name2)} ❤"
  end
end
