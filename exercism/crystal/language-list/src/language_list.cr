module LanguageList
  def self.list
    Array(String).new
  end

  def self.add(list, language)
    list << language
  end

  def self.remove(list)
    list.pop
    list
  end

  def self.at(list, index)
    list[index]
  end

  def self.parse(languages)
    languages.split(", ")
  end
end
