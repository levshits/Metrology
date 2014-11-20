require_relative '../code_pre_processor'
require_relative '../cpp_parser'
class Metric
  def get_result
    return "result as string"
  end
  def calculate_metric(code)
    result = ""
    code_preprocessor = CodePreProcessor.new
    result = code_preprocessor.pre_process(code)
    parser = CppParser.new()
    result = parser.parse(result)
    return result
  end
end