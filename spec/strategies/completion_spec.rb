describe 'the `completion` suggestion strategy' do
  let(:options) { ['ZSH_AUTOSUGGEST_STRATEGY=completion'] }
  let(:before_sourcing) do
    -> do
      session.
        run_command('autoload compinit && compinit').
        run_command('_foo() { compadd bar }').
        run_command('compdef _foo baz')
    end
  end

  it 'suggests the first completion result' do
    session.send_string('baz ')
    wait_for { session.content }.to eq('baz bar')
  end

  context 'when async mode is enabled' do
    before do
      skip 'Async mode not supported below v5.0.8' if session.zsh_version < Gem::Version.new('5.0.8')
    end

    let(:options) { ['ZSH_AUTOSUGGEST_USE_ASYNC=true', 'ZSH_AUTOSUGGEST_STRATEGY=completion'] }

    it 'suggests the first completion result' do
      session.send_string('baz ')
      wait_for { session.content }.to eq('baz bar')
    end
  end
end

