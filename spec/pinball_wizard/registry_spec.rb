require 'pinball_wizard'

describe PinballWizard::Registry do

  before(:each) do
    PinballWizard::Registry.clear
  end

  let(:default_feature) do
    PinballWizard::Feature.new 'default'
  end

  let(:not_available_feature) do
    PinballWizard::Feature.new 'not_available', available: false
  end

  describe '.add' do
    it 'should add to the registry with defaults' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.collection).to eq({
        'default' => default_feature
      })
    end
  end

  describe '.available?' do
    it 'should be false for a non-available feature' do
      PinballWizard::Registry.add(not_available_feature)
      expect(PinballWizard::Registry.available?('not_available')).to eq(false)
    end

    it 'should be false for a non-existant feature' do
      expect(PinballWizard::Registry.available?('foo')).to eq(false)
    end

    it 'should be true for an available feature' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.available?('default')).to eq(true)
    end
  end

  describe '.to_h' do
    it 'should build a hash' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.to_h).to eq({
        'default' => { 'available' => true, 'activateImmediately' => false }
      })
    end
  end
end
