require_relative '../runner'

describe 'describe' do
  describe 'nested describe' do
    it 'should still run this test' do
      expect(1 + 1).to eq 2
    end
  end
end

describe 'it' do
  it 'should not allow the inner it to run' do
    expect do
      it 'should not work' do
      end
    end.to raise_error(NameError)
  end
end

describe 'expectations' do
  it 'can expect values' do
    expect(1 + 1).to eq 2
  end

  it 'can expect exceptions' do
    expect { raise ArgumentError.new }.to raise_error(ArgumentError)
  end
end

describe 'let' do
  let(:five) { 5 }
  let(:six) { five + 1 }
  let(:random) { rand }

  it 'is avaiable inside the tests' do
    expect(five).to eq 5
  end

  it 'always returns the same object' do
    expect(random).to eq random
  end

  it "still fails when methods don't exist" do
    expect { method_that_doesnt_exist }.to raise_error(NameError)
  end

  it 'can reference other let variables' do
    expect(six).to eq 6
  end

  describe 'nested describes with lets' do
    let(:sibling_five) { 5 }
    it 'can reference lets in a parent describe' do
      expect(five).to eq 5
    end
  end

  describe 'sibling describes' do
    it 'cannot reference lets in a sibling describe' do
      expect { sibling_five }.to raise_error(NameError)
    end
  end
end

describe 'before' do
  before { @five = 5 }
  before { @six = @five + 1 }

  it 'should be visible inside the test' do
    expect(@five)
  end

  it 'can reference other before variables' do
    expect(@six).to eq 6
  end
end

describe 'let + before together' do
  let(:five) { 5 }
  before { @six = five + 1 }
  let(:seven) { @six + 1 }

  it 'allows befores to reference lets' do
    expect(@six).to eq 6
  end

  it 'allows lets to reference befores' do
    expect(seven).to eq 7
  end
end
