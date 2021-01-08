require_relative '../database'

describe Database do
  let(:db_url) { 'postgres://localhost/web_framework' }
  let(:queries) do
    {
      create: 'create table submissions (name text, email text)',
      drop: 'drop table if exists submissions',
      find_submissions:
        '
            select * from submissions
            where name = {name}
        ',
      create_submissions:
        '
            insert into submissions(name, email) 
            values({name}, {email})
        '
    }
  end
  let(:db) { Database.connect(db_url, queries) }

  before do
    db.drop
    db.create
  end

  it 'does not have sql injection vulnerabilities' do
    name = "'; drop table submissions; --"
    email = 'junk@nuk.com'
    expect { db.create_submissions(name: name, email: email) }.to change {
      db.find_submissions(name: name)
    }.by(1)
  end

  it 'retrieves proper records' do
    db.create_submissions(name: 'Alice', email: 'alice@example.com')
    alice = db.find_submissions(name: 'Alice').fetch(0)
    expect(alice.name).to eq 'Alice'
  end

  it "doesn't care about param order" do
    db.create_submissions(email: 'alice@example.com', name: 'Alice')
    alice = db.find_submissions(name: 'Alice').fetch(0)
    expect(alice.name).to eq 'Alice'
  end
end
