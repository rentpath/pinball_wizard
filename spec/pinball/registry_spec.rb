require 'pinball_wizard'

describe PinballWizard::Registry do

  before(:each) do
    PinballWizard::Registry.clear
  end

  let(:default_feature) do
    class DefaultFeature
      include PinballWizard::Feature
    end
    DefaultFeature
  end


  let(:not_available_feature) do
    class NotAvailableFeature
      include PinballWizard::Feature
      available false
    end
    NotAvailableFeature
  end

  describe '.add' do
    it 'should add to the registry with defaults' do
      PinballWizard::Registry.add(default_feature)
      expect(PinballWizard::Registry.collection).to eq({
        'default' => DefaultFeature
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
        'default' => { 'available' => true, 'activeByDefault' => false }
      })
    end
  end
end
