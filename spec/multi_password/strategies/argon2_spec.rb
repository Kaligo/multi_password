require 'multi_password/strategies/argon2'

RSpec.describe MultiPassword::Strategies::Argon2 do
  describe '#create and #verify' do
    let(:manager) { MultiPassword.new(algorithm: :argon2, options: options) }
    let(:options) { { t_cost: 2, m_cost: 16 } }

    it 'creates and verifies password correctly' do
      encrypted_password = manager.create('password')
      expect(encrypted_password).not_to eq 'password'
      expect(manager.verify('password', encrypted_password)).to eq true
    end
  end

  describe '#validate_options' do
    let(:strategy) { described_class.new }

    context 'when options are valid' do
      let(:options) { { t_cost: 2, m_cost: 16 } }

      it 'returns options' do
        expect(strategy.validate_options(options)).to eq(options)
        expect(strategy.validate_options({})).to eq({})
      end
    end

    context 'when options are invalid' do
      context 'when t_cost is invalid' do
        it 'raises error' do
          [5.5, 0, 751].each do |invalid_value|
            options = { t_cost: invalid_value, m_cost: 4 }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm argon2 options: t_cost must be an integer between 1 and 750')
          end
        end
      end

      context 'when m_cost is invalid' do
        it 'raises error' do
          [5.5, 0, 32].each do |invalid_value|
            options = { m_cost: invalid_value, t_cost: 1 }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm argon2 options: m_cost must be an integer between 1 and 31')
          end
        end
      end
    end
  end
end
