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
        feature :example_c, :active
        feature :example_d, available: proc { false }
      end
    end

    it 'adds to the registry' do
      expect(PinballWizard::Registry.to_h).to eq({
        'example_a' => { 'active' => false, 'available' => true  },
        'example_b' => { 'active' => false, 'available' => false },
        'example_c' => { 'active' => true,  'available' => true  },
        'example_d' => { 'active' => false, 'available' => false }
      })
    end
  end
end
