require_relative 'metric'
require_relative '../syntax_analyser'
class McKlureMetric<Metric
  private
  def calculate_metric
    @syntax_analyser.get_all_functions
    return '\n McKlure metric'
  end
end