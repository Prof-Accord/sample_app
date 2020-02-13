require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:michael) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }
  let!(:most_recent) { create(:most_recent, user: user) }
  let!(:orange) { create(:orange, user: user) }
  let!(:tau_mainfesto) { create(:tau_mainfesto, user: user) }
  
  it "有効であること" do
    expect(micropost).to be_valid
  end
  
  it "user_idが必要であること" do
    micropost.user_id = nil
    expect(micropost).not_to be_valid
  end
  
  it "contentが必要であること" do
    micropost.content = "   "
    expect(micropost).not_to be_valid
  end
  
  it "contentが140文字以内であること" do
    micropost.content = "a" * 141
    expect(micropost).not_to be_valid
  end
  
  it "新しく作成された順で並んでいること" do
    expect(most_recent).to eq Micropost.first
    expect(orange).to eq Micropost.second
    expect(tau_mainfesto).to eq Micropost.third
  end
end
