require 'multi_password/strategies/bcrypt'

RSpec.describe MultiPassword::Strategies::BCrypt do
  describe '#create and #verify' do
    let(:options) { { cost: 12 } }
    let(:manager) { MultiPassword.new(algorithm: :bcrypt, options: options) }

    it 'creates and verifies password correctly' do
      encrypted_password = manager.create('password')
      expect(encrypted_password).not_to eq 'password'
      expect(manager.verify('password', encrypted_password)).to eq true
    end
  end

  describe '#validate_options' do
    let(:strategy) { described_class.new }

    context 'when options are valid' do
      let(:options) { { cost: 12 } }

      it 'returns options' do
        expect(strategy.validate_options(options)).to eq(options)
      end
    end

    context 'when options are invalid' do
      context 'when cost is invalid' do
        it 'raises error' do
          [5.5, 3, 32].each do |invalid_value|
            options = { cost: invalid_value }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm bcrypt options: cost must be an integer between 4 and 31')
          end
        end
      end
    end
  end
end
