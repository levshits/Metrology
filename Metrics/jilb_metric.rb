require_relative 'metric'
require_relative '../syntax_analyser'
class JilbMetric<Metric
  private
  def calculate_metric
    @syntax_analyser = SyntaxAnalyser.new(@parser)
    absolute_value = get_if_count
    relative_value = absolute_value/@parser.operators_first_parts.size
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
    current_nesting_level = -1
    code_parts = @parser.code_parts
    operators_first_parts = @parser.operators_first_parts
    operators_other_parts = @parser.operators_other_parts
    operators_first_parts_index = 0
    operators_other_parts_index  = 0
    code_parts.each_index{|parts_index|

    if is_if_statement?(operators_first_parts[operators_first_parts_index])
      current_nesting_level+=1
      operators_first_parts_index+=1

    end
    }
    return max_nesting_level
  end
  def is_if_statement?(operator)
    return /if|switch|while/=~operator
  end
end