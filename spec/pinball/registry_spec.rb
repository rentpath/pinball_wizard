require 'pinball'

describe Pinball::Registry do

  before(:each) do
    Pinball::Registry.clear
  end

  let(:default_feature) do
    class DefaultFeature
      include Pinball::Feature
    end
    DefaultFeature
  end


  let(:not_available_feature) do
    class NotAvailableFeature
      include Pinball::Feature
      available false
    end
    NotAvailableFeature
  end

  describe '.add' do
    it 'should add to the registry with defaults' do
      Pinball::Registry.add(default_feature)
      expect(Pinball::Registry.collection).to eq({
        'default' => DefaultFeature
      })
    end
  end

  describe '.available?' do
    it 'should be false for a non-available feature' do
      Pinball::Registry.add(not_available_feature)
      expect(Pinball::Registry.available?('not_available')).to eq(false)
    end

    it 'should be false for a non-existant feature' do
      expect(Pinball::Registry.available?('foo')).to eq(false)
    end

    it 'should be true for an available feature' do
      Pinball::Registry.add(default_feature)
      expect(Pinball::Registry.available?('default')).to eq(true)
    end
  end

  describe '.to_json' do
    it 'should build a hash' do
      Pinball::Registry.add(default_feature)
      expect(Pinball::Registry.to_json).to eq({
        'default' => { 'available' => true, 'activeByDefault' => false }
      })
    end
  end
end
