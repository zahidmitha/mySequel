require 'spec_helper'

describe Sequel do
  fixtures :sequels
  it { should belong_to :director }
  it { should have_and_belong_to_many :genres }

  it "has fixtures inserted into the database" do
    Sequel.count.should eq 11
  end
end