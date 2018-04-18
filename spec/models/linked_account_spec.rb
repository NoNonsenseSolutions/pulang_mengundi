# frozen_string_literal: true

require 'rails_helper'

describe LinkedAccount do
  context 'self.create_with_omniauth' do
    let(:current_user) { create(:user) }

    %i[facebook twitter].each do |provider|
      context provider do
        let(:auth) { create(:auth_hash, provider) }

        context 'has existing linked account' do
          before { LinkedAccount.create_with_omniauth(auth, current_user) }
          context 'when logged in user is not linked account owner' do
            it 'fails' do
              expect do
                LinkedAccount.create_with_omniauth(auth, create(:user))
              end.to raise_error(LinkedAccount::UserOverwrittenError)
            end
          end

          context 'when logged in user is linked account owner' do
            it 'does nothing and returns user' do
              result = LinkedAccount.create_with_omniauth(auth, current_user)

              linked_account = LinkedAccount.find_by(uid: auth['uid'], provider: auth['provider'])
              expect(linked_account.updated_at).to eq(linked_account.created_at)

              expect(result).to eq(current_user)
            end
          end
        end

        context 'no existing linked account' do
          context 'there is a user logged in' do
            before { LinkedAccount.create_with_omniauth(auth, current_user) }
            it 'assigns user to linked account' do
              linked_account = LinkedAccount.find_by(uid: auth['uid'], provider: auth['provider'])
              expect(linked_account.user).to eq(current_user)
            end
          end

          context 'no logged in user' do
            context 'has existing user with email' do
              let(:auth) { create(:auth_hash, provider, email: current_user.email) }
              it 'assigns existing user to linked account' do
                LinkedAccount.create_with_omniauth(auth, nil)
                linked_account = LinkedAccount.find_by(uid: auth['uid'], provider: auth['provider'])
                expect(linked_account.user).to eq(current_user)
              end
            end

            context 'no existing user with email' do
              it 'creates and assigns user to linked account' do
                existing_user = User.find_by(email: auth.email)
                expect(existing_user).to be_nil

                LinkedAccount.create_with_omniauth(auth, nil)

                newly_created_user = User.find_by(email: auth['info']['email'])
                expect(newly_created_user).to_not be_nil

                linked_account = LinkedAccount.find_by(uid: auth['uid'], provider: auth['provider'])
                expect(linked_account.user).to eq(newly_created_user)
              end
            end
          end
        end
      end
    end
  end
end
