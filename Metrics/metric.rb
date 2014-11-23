require_relative '../code_pre_processor'
require_relative '../cpp_parser'
class Metric
  def get_result
    return "result as string"
  end
  def calculate(code)
    result = ""
    code_preprocessor = CodePreProcessor.new
    result = code_preprocessor.pre_process(code)
    @parser = CppParser.new()
    @parser.parse(result)
    @syntax_analyser = SyntaxAnalyser.new(@parser)
    result =  calculate_metric
    return result
  end
  private
  def calculate_metric
    return "\nIt's an abstract class"
  end
end