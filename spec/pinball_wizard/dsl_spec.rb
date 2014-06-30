require 'pinball_wizard'

describe PinballWizard::DSL do

  before(:each) do
    PinballWizard::Registry.clear
  end

  describe '.build' do
    context 'without builder class flags' do
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

      it 'createa a Feature class instance' do
        expect(PinballWizard::Registry.get('example_a')).to be_a(PinballWizard::Feature)
      end
    end

    context 'with a builder class flag' do

      class MyCustomFeature < PinballWizard::Feature
      end

      before(:each) do
        PinballWizard::DSL.build do
          class_patterns my_custom_feature: MyCustomFeature
          feature :example_a, :my_custom_feature
          feature :example_b
        end
      end

      it 'adds to the registry' do
        expect(PinballWizard::Registry.to_h).to eq({
          'example_a' => { 'active' => false, 'available' => true },
          'example_b' => { 'active' => false, 'available' => true }
        })
      end

      it 'createa a custom class instance for the specified' do
        expect(PinballWizard::Registry.get('example_a')).to be_a(MyCustomFeature)
      end

      it 'createa a Feature class instance for the non-specified' do
        expect(PinballWizard::Registry.get('example_b')).to be_a(PinballWizard::Feature)
      end

    end
  end
end
