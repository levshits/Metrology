class CodePreProcessor
  def pre_process(code)
    @code = code
    @code.strip!
    remove_comments
    remove_empty_strings
    remove_compiler_instructions
    remove_string_costants
    return @code
  end
  private
  def remove_comments
    @code.gsub!(/\/{2}.+/,'')
    @code.gsub!(/\/\*[^\0]*\*\//,'')
  end
  def remove_empty_strings
    @code.gsub!(/^$\n\r/,'')
    @code.gsub!(/^$\n/,'')
  end
  def remove_compiler_instructions
    @code.gsub!(/#[^d]+.*/,'')
  end
  def remove_string_costants
    @code.gsub!(/".*"/,'<string/>')
  end
end