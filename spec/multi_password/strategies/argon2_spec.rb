require 'multi_password/strategies/argon2'

RSpec.describe MultiPassword::Strategies::Argon2 do
  let(:options) { { m_cost: 16 } }
  let(:manager) { MultiPassword.new(algorithm: :argon2, options: options) }

  it 'creates and verifies password correctly' do
    encrypted_password = manager.create('password')
    expect(encrypted_password).not_to eq 'password'
    expect(manager.verify('password', encrypted_password)).to eq true
  end
end
