class CppParser
  @numbers_list = []
  @list_of_operators_first_parts = []
  @list_of_operators_other_parts=[]
  @identificators_list = []
  @code_parts = []

  def parse(code)
    @code = code
    # Attention. Order of operations is important
    find_all_numbers
    find_all_operators_first_parts
    find_all_operators_other_parts
    find_all_identificators
    split_to_parts
  end
  def code_parts
    return @code_parts
  end
  def operators_first_parts
    return @list_of_operators_first_parts
  end
  def operators_other_parts
    return @list_of_operators_other_parts
  end
  def numbers_list
    return @numbers_list
  end
  def identificators_list
    return @identificators_list
  end
  def current_operators_first_part_index(code_parts_index)
    result = 0
    (0...code_parts_index).each{|index|
    if @code_parts[index] == 'op_first'
      result+=1
    end}
    return result
  end
  def current_operators_other_part_index(code_parts_index)
    result = 0
    (0...code_parts_index).each{|index|
      if @code_parts[index] == 'op_other'
        result+=1
      end}
    return result
  end
  def current_id_index(code_parts_index)
    result = 0
    (0...code_parts_index).each{|index|
      if @code_parts[index] == 'id'
        result+=1
      end}
    return result
  end
  private
  def find_all_numbers
    regex = /[-+]?\b[0-9]*\.?[0-9]+[fd]?\b/
    @numbers_list = @code.scan(regex)
    @code.gsub!(regex,' 1num1 ')
  end
  def find_all_operators_first_parts
    regex = /\++|--|\+=|%|-=|\|=|\/=|\*=|->|>=|<=|>+|<+|!=|\|\||&+|[*]+|=+|-|\+|\.|\[|\/|!|~|\^|::|if|while|for|switch/
    @list_of_operators_first_parts = @code.scan(regex)
    @code.gsub!(regex, ' 1op_first1 ')
  end
  def find_all_operators_other_parts
    regex = /case|else|do/
    @list_of_operators_other_parts = @code.scan(regex)
    @code.gsub!(regex, ' 1op_other1 ')
  end
  def find_all_identificators
    regex = /\b[A-Za-z_][A-Za-z_0-9]*\b/
    @identificators_list = @code.scan(regex)
    @code.gsub!(regex,' id ')
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
    @code.gsub!('1','')
    @code_parts=@code.scan /[^ ]+/
  end
end