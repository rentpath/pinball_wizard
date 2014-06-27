require 'pinball_wizard'

describe PinballWizard::Feature do

  describe '#available?' do
    context 'without setting a value' do
      subject { PinballWizard::Feature.new 'example' }

      it 'should be available' do
        expect(subject).to be_available
      end
    end

    context 'with a boolean value' do
      subject do
        PinballWizard::Feature.new 'example', available: false
      end

      it 'should not be available' do
        expect(subject).not_to be_available
      end
    end

    context 'with a proc' do
      subject do
        PinballWizard::Feature.new 'example', available: proc { false }
      end

      it 'should not be available' do
        expect(subject).not_to be_available
      end
    end
  end

  describe '#activate_immediately?' do
    context 'without setting a value' do
      subject { PinballWizard::Feature.new 'example' }

      it 'should be activated' do
        expect(subject).not_to be_activate_immediately
      end
    end

    context 'with a boolean value' do
      subject do
        PinballWizard::Feature.new 'example', activate_immediately: true
      end

      it 'should not be activated' do
        expect(subject).to be_activate_immediately
      end
    end

    context 'with a proc' do
      subject do
        PinballWizard::Feature.new 'example', activate_immediately: proc { true }
      end

      it 'should not be activated' do
        expect(subject).to be_activate_immediately
      end
    end
  end

  describe '#name' do
     context 'with a long name' do
      subject do
        PinballWizard::Feature.new 'my_super_duper'
      end

      it 'should underscore the name' do
        expect(subject.name).to eq('my_super_duper')
      end
    end
  end

  describe '#to_h' do
    context 'using defaults' do
      subject { PinballWizard::Feature.new 'example' }

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: true,
          activate_immediately: false
        })
      end
    end

    context 'when using boolean values' do
      subject do
        PinballWizard::Feature.new 'example', available: false, activate_immediately: true
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          activate_immediately: true
        })
      end
    end

    context 'when using procs' do
      subject do
        PinballWizard::Feature.new('example', {
          available:            proc { false },
          activate_immediately: proc { true }
        })
      end

      it 'should build a hash' do
        expect(subject.to_h).to eq({
          available: false,
          activate_immediately: true
        })
      end
    end
  end

  describe '.new' do
    it 'takes in an array of symbols and converts them to a hash' do
      feature = PinballWizard::Feature.new 'example', :foo, :bar
      expect(feature.options).to eq({ foo: true, bar: true })
    end

    it 'takes a hash of options' do
      feature = PinballWizard::Feature.new 'example', foo: 'bar'
      expect(feature.options).to eq({ foo: 'bar' })
    end

    it 'merges an array of symbols and hash of options' do
      feature = PinballWizard::Feature.new 'example', :a, :b, foo: 'bar'
      expect(feature.options).to eq({ a: true, b: true, foo: 'bar' })
    end
  end
end
