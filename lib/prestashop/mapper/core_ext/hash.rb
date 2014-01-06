Hash.class_eval do 
  def clean!
    reject{|k,v| v.nil? or v.empty?}
  end

  def lang_search value
    if self[:language].kind_of?(Array) 
      self[:language].find{|l| l[:val] == value and l[:attr][:id] == Prestashop::Client.settings.id_language}
    else
      self[:language][:val] == value and self[:language][:attr][:id] == Prestashop::Client.settings.id_language
    end
  end
end