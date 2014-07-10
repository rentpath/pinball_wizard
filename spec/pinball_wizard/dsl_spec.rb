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
          feature :example_b, :active
          feature :example_c, active: proc { false }
        end
      end

      it 'adds to the registry' do
        expect(PinballWizard::Registry.to_h).to eq({
          'example_a' => 'inactive',
          'example_b' => 'active',
          'example_c' => 'inactive'
        })
      end

      it 'creates a Feature class instance' do
        expect(PinballWizard::Registry.get('example_a')).to be_a(PinballWizard::Feature)
      end
    end

    context 'with a builder class flag' do

      class MyCustomFeature < PinballWizard::Feature; end

      let(:config) do
        PinballWizard::Configuration.new my_custom_feature: MyCustomFeature
      end

      before(:each) do
        PinballWizard::DSL.build(config) do
          feature :example_a, :my_custom_feature
          feature :example_b, :foo, my_custom_feature: { b: true }
          feature :example_c
        end
      end

      it 'adds to the registry' do
        expect(PinballWizard::Registry.to_h).to eq({
          'example_a' => 'inactive',
          'example_b' => 'inactive',
          'example_c' => 'inactive'
        })
      end

      it 'creates a custom class instance when given a symbol' do
        expect(PinballWizard::Registry.get('example_a')).to be_a(MyCustomFeature)
      end

      it 'creates a custom class instance when given a hash' do
        expect(PinballWizard::Registry.get('example_b')).to be_a(MyCustomFeature)
      end

      it 'createa a Feature class instance for the non-specified' do
        expect(PinballWizard::Registry.get('example_c')).to be_a(PinballWizard::Feature)
      end

      it 'passes on symbols and hash into Feature options' do
        expect(PinballWizard::Registry.get('example_b').options).to eq({ foo: true, my_custom_feature: { b: true } })
      end
    end
  end
end
