class CppParser
  @numbers_list = []
  @operators_list = []
  @identificators_list = []
  @code_parts = []

  def parse(code)
    @code = code
    # Attention. Order of operations is important
    find_all_identificators
    find_all_numbers
    find_all_operators
    split_to_parts
    return @code
  end
  private
  def find_all_identificators
    regex = /\b[A-Za-z_][A-Za-z_0-9]*\b/
    @identificators_list = @code.scan(regex)
    @code.gsub!(regex,' id ')
  end
  def find_all_numbers
    regex = /[-+]?\b[0-9]*\.?[0-9]+(f|d)?\b/
    @numbers_list = @code.scan(regex)
    @code.gsub!(regex,' num ')
  end
  def find_all_operators
    regex = /\++|--|\+=|-=|\|=|\/=|\*=|->|>=|<=|>+|<+|!=|\|\||&+|[*]+|=+|-|\+|\.|\[|\/|!|~|\^|::/
    @operators_list = @code.scan(regex)
    @code.gsub!(regex, ' op ')
  end
  def split_to_parts
    @code.gsub!(/;/,' ; ')
    @code.gsub!(/\{/,' { ')
    @code.gsub!(/\}/,' } ')
    @code.gsub!(/\(/,' ( ')
    @code.gsub!(/\)/,' ) ')
    @code.gsub!(/,/,' , ')
    @code.gsub!(/\[/,' [ ')
    @code.gsub!(/\]/,' ] ')
    @code_parts=@code.scan /[^ ]+/
  end

end