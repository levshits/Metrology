require_relative 'cpp_parser'
require_relative 'syntax_analyser_function_view'
class SyntaxAnalyser
  def initialize(parser)
    @parser = parser
  end

  def get_body_length(code_parts_index)
    result = 0
    if @parser.code_parts[code_parts_index]!='{'
      while(@parser.code_parts[code_parts_index+result]!=';')
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
  def get_all_functions
    find_all_possible_funct_definitions_names
  end
  private
  def get_pair_code_parts_length(index, first_part, second_part)
    result = index
    pair_count = 0
    while(pair_count!=1||@parser.code_parts[result]!=second_part)
      if @parser.code_parts[result]==first_part
        pair_count+=1
      elsif
       @parser.code_parts[result]==second_part
        pair_count-=1
      end
        result+=1
    end
    result+=1
    return result-index
  end
  def find_all_possible_funct_definitions_names
    #6 - minimal count of components in funct definition
    possible_functs = []
    code_parts = @parser.code_parts
    (0..code_parts.size-6).each{|index|
      if code_parts[index] == 'id'
        if code_parts[index+1] == 'id'
          if code_parts[index+2] == '('
            possible_functs.push(SyntaxAnalyserFunctionView.new(index+1, index+2,0))
          end
        elsif code_parts[index+1] == 'op_first' &&
            @parser.operators_first_parts[@parser.current_operators_first_part_index(index+1)]=='::'
          if code_parts[index+2] == 'id'
            if code_parts[index+3]=='('
              possible_functs.push(SyntaxAnalyserFunctionView.new(index+2, index+3,0))
            end
          elsif code_parts[index+2] == 'op_first' &&
              @parser.operators_first_parts[@parser.current_operators_first_part_index(index+2)]=='~'
            if code_parts[index+3] == 'id'
              if code_parts[index+4]=='('
                possible_functs.push(SyntaxAnalyserFunctionView.new(index+3, index+4,0))
              end
            end
          end
        end
      end
    }

    if(possible_functs.size>0)
    possible_functs = possible_functs.select{|funct| check_function_definition?(funct) }
    end
    p possible_functs
  end
  def check_function_definition?(funct)
    result = false
    if(funct!=nil)
      code_parts = @parser.code_parts
      params_lenght = get_condition_length(funct.params_index)
      if(code_parts[funct.params_index+params_lenght]=='{')
        funct.code_index = funct.params_index+params_lenght
        funct.name = @parser.identificators_list[@parser.current_id_index(funct.name_index)]
        parse_import_params(funct, params_lenght)
        result = true
      elsif code_parts[funct.params_index+params_lenght]==':'
        index = funct.params_index+params_lenght
        while(index<code_parts.size && code_parts[index]!='{')

          index+=1
        end
        funct.code_index=index
        funct.code_index = funct.params_index
        funct.name = @parser.identificators_list[@parser.current_id_index(funct.name_index)]
        parse_import_params(funct, params_lenght)
        result = true
      end
    end
    return result
  end
  def find_export_parameters(funct, code_section_lenght)
    code_parts = @parser.code_parts
    functions_callings = []
    if(code_section_lenght>2)
      (funct.code_index..funct.code_index+code_section_lenght-1).each{|index|
      if code_parts[index] =='id'
        if code_parts[index+1] == '('
          functions_callings.push(index)
        end
      end}
      if functions_callings.size>0
        (0..functions_callings.size).each{|calling_index|
        }
      end
      end
  end
  def parse_calling_funct_params(funct, params_index)
    index = params_index
    while(@parser.code_parts[index]!=')')
      if @parser.code_parts[index]!='id'
      end
    end
  end
  def parse_import_params(funct, params_lenght)
    code_parts = @parser.code_parts
    params =[]
    if(params_lenght>2)
    (funct.params_index..funct.params_index+params_lenght).each{|index|
      if code_parts[index]==',' or (params_lenght>2 and code_parts[index]==')')
        params.push(@parser.identificators_list[@parser.current_id_index(index-1)])
      end
    }
    end
    funct.add_import_params(params)
  end
end