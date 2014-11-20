require 'tk'
require_relative 'code_pre_processor'
require_relative 'Metrics/metric'
require_relative 'Metrics/jilb_metric'
require_relative 'Metrics/mc_klure_metric'

class Main
  $radiobutton_group_control_variable
  @selected_metric
  def initialize
    @selected_metric = JilbMetric.new
    @root = TkRoot.new('title'=>'Metrology') do
       minsize(500,400)
     end
    @button_frame  = TkFrame.new(@root) do
      pack('fill'=>'x', 'side'=>'top')
      padx 10
      pady 10
    end
    create_buttons
    @code_frame = TkFrame.new(@root) do
      pack('fill'=>'both', 'expand'=>'yes')
      padx 10
      pady 10
      background 'blue'
    end
    TkLabel.new(@code_frame, 'text'=>'Source code').pack('anchor'=>'w')
    @code_text = TkText.new(@code_frame) do
      pack('fill'=>'both', 'expand'=>'yes')
    end
    TkLabel.new(@code_frame, 'text'=>'Results').pack('anchor'=>'w')
    @results_text = TkText.new(@code_frame) do
      pack('fill'=>'x')
      height 10
    end
    bind_ui_elements
  end
  def run
    Tk.mainloop
  end
  private
  def create_buttons
    @open_button = TkButton.new(@button_frame, 'text' => 'Open') do
      pack('side'=>'left')
    end
    @calculate_button = TkButton.new(@button_frame, 'text' => 'Calculate metric') do
      pack('side'=>'left')
    end
    radiobuttons_frame = TkFrame.new(@button_frame) do
      pack('side'=>'left')
    end
    $radiobutton_group_control_variable = TkVariable.new('jilb')
    @jilb_radiobutton = TkRadioButton.new(radiobuttons_frame) {
      text 'Jilb metric'
      variable $radiobutton_group_control_variable
      value 'jilb'
      anchor 'w'
      pack('side' => 'top', 'fill' => 'x')
    }
    @mcklure_radiobutton = TkRadioButton.new(radiobuttons_frame) {
      text 'McKlure metric'
      variable $radiobutton_group_control_variable
      value 'mcklure'
      anchor 'w'
      pack('side' => 'top', 'fill' => 'x')
    }
  end
  def bind_ui_elements
    @open_button.command = proc{openbutton_click}
    @calculate_button.command = proc{calculate_click}
    @mcklure_radiobutton.command = proc{ select_metric}
    @jilb_radiobutton.command = proc{ select_metric}
  end
  def openbutton_click
    filename =  Tk.getOpenFile
    if !(filename.empty?)
      @code_text.value = File.open(filename){|file| file.read}
    end
  end
  def calculate_click
    @results_text.value = @selected_metric.calculate_metric(@code_text.value)
  end
  def select_metric
    if($radiobutton_group_control_variable=='jilb')
      @selected_metric = JilbMetric.new
    else
      @selected_metric = McKlureMetric.new
    end
  end
end

program = Main.new
program.run