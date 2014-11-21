require_relative 'cpp_parser'
class SyntaxAnalyser
  def initialize(parser)
    @parser = parser
  end
  def get_body_length(code_parts_index)
    result = code_parts_index
    if @parser.code_parts[result]!='{'
      while @parser.code_parts[result]!=';'
        result+=1
      end
      result+=1
    else
      result = get_pair_code_parts_length(code_parts_index,'{','}')
    end
    return result
  end
  def get_condition_length(code_parts_index)
    return get_pair_code_parts_length(code_parts_index,'(',')')
  end
  private
  def get_pair_code_parts_length(index, first_part, second_part)
    result = index
    pair_count = 0
    while(pair_count!=1&&@parser.code_parts[result]!=second_part)
      if @parser.code_parts[result]==first_part
        pair_count+=1
      elsif
       @parser.code_parts[result]==second_part
        pair_count-=1
      end
        result+=1
    end
    result+=1
  end
end