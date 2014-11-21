class CodePreProcessor
  def pre_process(code)
    @code = code
    # Attention. Order of operations is important
    @code.strip!
    remove_comments
    remove_empty_strings
    remove_compiler_instructions
    remove_string_constants
    remove_escape_sequensies
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
  def remove_string_constants
    @code.gsub!(/".*"/,'""')
  end
  def remove_escape_sequensies
    @code.gsub!(/\s/,' ')
  end
end