require 'pinball_wizard'

describe PinballWizard::Feature do

  describe '.available?' do
    context 'without setting a value' do
      subject do
        Class.new do
          include PinballWizard::Feature
        end
      end

      it 'should be available' do
        expect(subject).to be_available
      end
    end

    context 'with a boolean value' do
      subject do
        Class.new do
          include PinballWizard::Feature

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
          include PinballWizard::Feature

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

  describe '.activate_immediately?' do
    context 'without setting a value' do
      subject do
        Class.new do
          include PinballWizard::Feature
        end
      end

      it 'should be activated' do
        expect(subject).not_to be_activate_immediately
      end
    end

    context 'with a boolean value' do
      subject do
        Class.new do
          include PinballWizard::Feature

          activate_immediately true
        end
      end

      it 'should not be activated' do
        expect(subject).to be_activate_immediately
      end
    end

    context 'with a block' do
      subject do
        Class.new do
          include PinballWizard::Feature

          activate_immediately do
            true
          end
        end
      end

      it 'should not be activated' do
        expect(subject).to be_activate_immediately
      end
    end
  end

  describe '.registry_name' do
     context 'with a long name' do
      subject do
        class MySuperDuperFeature
          include PinballWizard::Feature
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
          include PinballWizard::Feature
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
          include PinballWizard::Feature
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: true,
          activate_immediately: false
        })
      end
    end

    context 'when using boolean values' do
      subject do
        Class.new do
          include PinballWizard::Feature

          available false

          activate_immediately true
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          activate_immediately: true
        })
      end
    end

    context 'when using blocks' do
      subject do
        Class.new do
          include PinballWizard::Feature

          available do
            false
          end

          activate_immediately do
            true
          end
        end
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          activate_immediately: true
        })
      end
    end
  end
end
