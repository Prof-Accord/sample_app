require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:michael) }
  let(:other_user) { create(:archer) }
  let(:relationship) { Relationship.new(follower_id: user.id,
                                        followed_id: other_user.id) }
  it "有効であること" do
    expect(relationship).to be_valid
  end
  it "follower_idが必要であること" do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end
  it "followed_idが必要であること" do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
