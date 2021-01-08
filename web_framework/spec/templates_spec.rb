require_relative '../templates'

class Templates
    describe Template do
        it 'renders templates' do
            source = <<~END
              div
                p
                  | User:
                p
                  = email
            END
            expected = <<~END
              <div>
                <p>
                  User:
                </p>
                <p>
                  alice@example.com
                </p>
              </div>
            END
            rendered = Template.new(source).render(email: 'alice@example.com')
            expect(rendered).to eq expected
        end
    end
end