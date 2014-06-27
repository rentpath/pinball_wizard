require 'pinball_wizard'

describe PinballWizard::DSL do

  before(:each) do
    PinballWizard::Registry.clear
  end

  describe '.build' do
    before(:each) do
      PinballWizard::DSL.build do
        feature :example_a
        feature :example_b, available: false
        feature :example_c, :activate_immediately
        feature :example_d, available: proc { false }
      end
    end

    it 'adds to the registry' do
      expect(PinballWizard::Registry.to_h).to eq({
        'example_a' => { 'available' => true,  'activateImmediately' => false },
        'example_b' => { 'available' => false, 'activateImmediately' => false },
        'example_c' => { 'available' => true,  'activateImmediately' => true  },
        'example_d' => { 'available' => false, 'activateImmediately' => false }
      })
    end
  end
end
