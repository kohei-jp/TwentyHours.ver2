require 'rails_helper'
describe User do
  describe '#create' do
    # 1. nameとemail、passwordとpassword_confirmationが存在すれば登録できること
    it "is valid with a name, email, password, password_confirmation" do
      user = build(:user)
      expect(user).to be_valid
    end

    # 2. nameが空では登録できないこと
    it "is invalid without a name" do
      user = build(:user, name: "")
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    # 3. emailが空では登録できないこと
    it "is invalid without an email" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    # 4. passwordが空では登録できないこと
    it "is invalid without a password" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    # 5. passwordが存在してもpassword_confirmationが空では登録できないこと
    it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    # 6. nameが7文字以上であれば登録できないこと
    it "is invalid with a name that has more than 7 characters " do
      user = build(:user, name: "aaaaaaaa")
      user.valid?
      expect(user.errors[:name]).to include("は6文字以内で入力してください")
    end

    # 7. nameが6文字以下では登録できること
    it "is valid with a name that has less than 6 characters " do
      user = build(:user, name: "aaaaaa")
      expect(user).to be_valid
    end

    # 8. emailに@が含まれない場合では登録出来ないこと
    it "is invalid with an email that has no  @ " do
      user = build(:user, email: "aaaagmail.com")
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です")
    end

    # 9. emailにドット(.)が含まれない場合では登録出来ないこと
    it "is invalid with an email that has no  dot " do
      user = build(:user, email: "aaaa@gmailcom")
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です")
    end

    # 10. 重複したemailが存在する場合登録できないこと
    it "is invalid with a duplicate email address" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    # 11. passwordが6文字以上であれば登録できること
    it "is valid with a password that has more than 6 characters " do
      user = build(:user, password: "aaa111", password_confirmation: "aaa111")
      user.valid?
      expect(user).to be_valid
    end

    # 12. passwordが5文字以下であれば登録できないこと
    it "is invalid with a password that has less than 6 and including alphanumeric characters   " do
      user = build(:user, password: "aaa11", password_confirmation: "aaa11")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上の英字と数字両方を含むパスワードを設定してください")
    end
  end
end
