require 'rails_helper'

RSpec.describe Client, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#save' do
    let(:client_01) { Client.new(name: 'Taro', email: 'taro@example.com', 'password': 'testtest') }
    let(:client_02) { Client.new(name: 'Jiro', email: 'taro@example.com', 'password': 'testtest') }

    subject { client_02.save }

    it '新規登録' do
      is_expected.to be_truthy
    end

    describe '重複' do
      before(:each) { client_01.save }

      it '重複チェック' do
        is_expected.to be_falsey
      end

      it '論理削除後再登録' do
        client_01.soft_destroy
        is_expected.to be_truthy
      end
    end
  end
end
