require_relative 'metric'
require_relative '../syntax_analyser'
class JilbMetric<Metric
  private
  def calculate_metric
    absolute_value = get_if_count
    relative_value = absolute_value.to_f/@parser.operators_first_parts.size
    max_nesting_level = get_max_nesting_level_of_if
    return "Jilb metric result:\n
            Absolute value #{absolute_value}\n
            Relative value #{relative_value}\n
            Max nesting level #{max_nesting_level}\n"
  end
  def get_if_count
    return @parser.operators_first_parts.find_all(){|operator| is_if_statement?(operator)}.size
  end
  def get_max_nesting_level_of_if
    max_nesting_level = 0
    if(is_codeblock_contains_if_statement?(0,@parser.code_parts.size))
      max_nesting_level = (get_max_nesting_level_of_current_if_statement(0, @parser.code_parts.size))[0]
    end
    return max_nesting_level
  end
  def get_max_nesting_level_of_current_if_statement(start_index, length)
    max_nesting_level = 0
    current_index = start_index
    while(start_index+length>current_index)
      if @parser.code_parts[current_index] == 'op_first'
        if_statement_index = @parser.current_operators_first_part_index(current_index)
        if is_if_statement?(@parser.operators_first_parts[if_statement_index])
          current_index+=@syntax_analyser.get_condition_length(current_index+1)+1
          body_length = @syntax_analyser.get_body_length(current_index)
          operator = @parser.operators_first_parts[if_statement_index]
          if(is_codeblock_contains_if_statement?(current_index,body_length))
            temp = get_max_nesting_level_of_current_if_statement(current_index, body_length)
            if(temp[0]>=max_nesting_level)
              max_nesting_level+=temp[0]+1
            end
            current_index=temp[1]+1
          else
            current_index+=body_length
            end
          if(operator == 'if')
            if(@parser.code_parts[current_index]=='op_other')
              if(@parser.operators_other_parts[@parser.current_operators_other_part_index(current_index)]=='else')
                current_index +=1
                body_length = @syntax_analyser.get_body_length(current_index)
                if(is_codeblock_contains_if_statement?(current_index,body_length))
                  temp = get_max_nesting_level_of_current_if_statement(current_index, body_length)
                  if(temp[0]>=max_nesting_level)
                    max_nesting_level+=temp[0]+1
                  end
                  current_index=temp[1]+1
                else
                  current_index+=body_length
                end
              end
            else
              current_index-=1
            end

          end
        end
        end
      current_index+=1
    end
    return [max_nesting_level, current_index]
  end
  def is_if_statement?(operator)
    return /if|for|switch|while|case|then/=~operator
  end
  def is_codeblock_contains_if_statement?(start_index, block_length)
    result = false
    (0..block_length-1).each{|index|
      if(@parser.code_parts[start_index+index]=='op_first')
        if(!result&&is_if_statement?(@parser.operators_first_parts[@parser.current_operators_first_part_index(start_index+index)]))
          result = true
        end
      end
    }
    return result
  end
end