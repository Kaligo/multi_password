require 'multi_password/strategies/bcrypt'

RSpec.describe MultiPassword do
  after { described_class.reset_config }

  it 'has a version number' do
    expect(MultiPassword::VERSION).not_to be nil
  end

  describe '.configure' do
    let(:strategy) { MultiPassword::Strategies::BCrypt.new }
    let(:options) { { cost: 4 } }

    subject do
      described_class.configure do |config|
        config.default_algorithm = :bcrypt
        config.default_options = options
      end
    end

    before do
      expect(MultiPassword::Strategies::BCrypt).to receive(:new)
        .and_return(strategy)
      expect(strategy).to receive(:validate_options).with(options)
        .and_return(options)
    end

    it 'can be configured' do
      subject

      config = described_class.config
      expect(config.default_algorithm).to eq :bcrypt
      expect(config.default_options).to eq({ cost: 4 })
    end
  end

  describe '.register' do
    let(:klass) { Class.new }
    let(:algorithm) { :dummy }

    after { described_class.unregister(algorithm) }

    context 'when algorithm is not registered yet' do
      it 'sets correct value' do
        expect {
          described_class.register(algorithm, klass)
        }.to change { described_class.registers[algorithm] }
          .from(nil).to(klass)
      end
    end

    context 'when algorithm is registered' do
      it 'sets correct value with warning' do
        expect(Warning).to receive(:warn)

        expect {
          described_class.register(algorithm, Class.new)
          described_class.register(algorithm, klass)
        }.to change { described_class.registers[algorithm] }
          .from(nil).to(klass)
      end
    end
  end

  describe '#initialize' do
    let(:strategy) { MultiPassword::Strategies::BCrypt.new }
    let(:options) { { cost: 4 } }

    subject { described_class.new(algorithm: :bcrypt, options: options) }

    it 'validates the options' do
      expect(MultiPassword::Strategies::BCrypt).to receive(:new)
        .and_return(strategy)
      expect(strategy).to receive(:validate_options).with(options)
        .and_return(options)

      subject
    end
  end

  describe '#create' do
    let(:options) { { cost: 12 } }
    let(:manager) { described_class.new(algorithm: algorithm, options: options) }
    let(:password) { 'password' }
    subject { manager.create(password) }

    context 'when algorithm is not registered' do
      let(:algorithm) { :dummy }

      it 'raises error' do
        expect {
          subject
        }.to raise_error(described_class::AlgorithmNotRegistered, /Algorithm dummy is not registered. Try requiring 'multi_password\/strategies\/dummy'\./)
      end
    end

    context 'when algorithm is registered' do
      let(:algorithm) { :bcrypt }
      let(:encrypted_password) { 'encrypted_password' }

      before do
        expect_any_instance_of(described_class::Strategies::BCrypt).to receive(:create)
          .with(password, options).and_return(encrypted_password)
      end

      it { is_expected.to eq encrypted_password }
    end
  end

  describe '#verify' do
    let(:options) { { cost: 12 } }
    let(:manager) { described_class.new(algorithm: algorithm, options: options) }
    let(:password) { 'password' }
    let(:encrypted_password) { 'encrypted_password' }
    subject { manager.verify(password, encrypted_password) }

    context 'when algorithm is not registered' do
      let(:algorithm) { :dummy }

      it 'raises error' do
        expect {
          subject
        }.to raise_error(described_class::AlgorithmNotRegistered, /Algorithm dummy is not registered. Try requiring 'multi_password\/strategies\/dummy'\./)
      end
    end

    context 'when algorithm is registered' do
      let(:algorithm) { :bcrypt }

      before do
        expect_any_instance_of(described_class::Strategies::BCrypt).to receive(:verify)
          .with(password, encrypted_password).and_return(true)
      end

      it { is_expected.to eq true }
    end
  end
end
