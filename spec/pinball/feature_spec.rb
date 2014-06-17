require 'pinball'

describe Pinball::Feature do

  describe '.available?' do
    context 'without setting a value' do
      subject do
        Class.new do
          include Pinball::Feature
        end
      end

      it 'should be available' do
        expect(subject).to be_available
      end
    end

    context 'with a boolean value' do
      subject do
        Class.new do
          include Pinball::Feature

          available false
        end
      end

      it 'should not be available' do
        expect(subject).not_to be_available
      end
    end

    context 'with a block' do
      subject do
        Class.new do
          include Pinball::Feature

          available do
            false
          end
        end
      end

      it 'should not be available' do
        expect(subject).not_to be_available
      end
    end
  end

  describe '.active_by_default?' do
    context 'without setting a value' do
      subject do
        Class.new do
          include Pinball::Feature
        end
      end

      it 'should be active by default' do
        expect(subject).not_to be_active_by_default
      end
    end

    context 'with a boolean value' do
      subject do
        Class.new do
          include Pinball::Feature

          active_by_default true
        end
      end

      it 'should not be active by default' do
        expect(subject).to be_active_by_default
      end
    end

    context 'with a block' do
      subject do
        Class.new do
          include Pinball::Feature

          active_by_default do
            true
          end
        end
      end

      it 'should not be active by default' do
        expect(subject).to be_active_by_default
      end
    end
  end

  describe '.registry_name' do
     context 'with a long name' do
      subject do
        class MySuperDuperFeature
          include Pinball::Feature
        end
        MySuperDuperFeature
      end

      it 'should underscore the name' do
        expect(subject.registry_name).to eq('my_super_duper')
      end
    end

    context 'with "Feature" in the class name' do
      subject do
        class SuperFeature
          include Pinball::Feature
        end
        SuperFeature
      end

      it 'should not repeat feature' do
        expect(subject.registry_name).to eq('super')
      end
    end
  end
  describe '.to_h' do
    context 'using defaults' do
      subject do
        Class.new do
          include Pinball::Feature
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: true,
          active_by_default: false
        })
      end
    end

    context 'when using boolean values' do
      subject do
        Class.new do
          include Pinball::Feature

          available false

          active_by_default true
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          active_by_default: true
        })
      end
    end

    context 'when using blocks' do
      subject do
        Class.new do
          include Pinball::Feature

          available do
            false
          end

          active_by_default do
            true
          end
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          active_by_default: true
        })
      end
    end
  end
end
