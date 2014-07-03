require 'pinball_wizard'

describe PinballWizard::Registry do

  before(:each) do
    PinballWizard::Registry.clear
  end

  let(:default_feature) do
    PinballWizard::Feature.new 'default'
  end

  class DisabledFeature < PinballWizard::Feature
    def determine_state
      disable 'Reason'
    end
  end

  let(:disabled_feature) do
    DisabledFeature.new 'disabled'
  end

  describe '.add' do
    it 'should add to the registry with defaults' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.collection).to eq({
        'default' => default_feature
      })
    end
  end

  describe '.disabled?' do
    it 'should be true for a disabled feature' do
      PinballWizard::Registry.add(disabled_feature)
      expect(PinballWizard::Registry.disabled?('disabled')).to eq(true)
    end

    it 'should be true for a non-existant feature' do
      expect(PinballWizard::Registry.disabled?('foo')).to eq(true)
    end

    it 'should be false for a active feature' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.disabled?('default')).to eq(false)
    end
  end

  describe '.to_h' do
    it 'should build a hash' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.to_h).to eq({
        'default' => 'inactive'
      })
    end
  end
end
