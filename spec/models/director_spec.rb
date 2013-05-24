require "spec_helper"

describe Director do
  fixtures :directors
  it { should have_many :sequels }

  it "has fixtures inserted into the database" do
    Director.count.should eq 8
  end
end