class SyntaxAnalyserFunctionView
  attr_accessor :name_index, :params_index, :code_index, :name
  import_params_id = []
  export_params_id = []
  def initialize(name_index, params_index, code_index)
    self.name_index = name_index
    self.params_index = params_index
    self.code_index =code_index
  end
  def add_import_params(params)
    import_params_id = params
  end
  def include_parameter?(name)
    return import_params_id.include?(name)
  end
end