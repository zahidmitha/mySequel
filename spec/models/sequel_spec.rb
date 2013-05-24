require 'spec_helper'

describe Sequel do
  it { should belong_to :director }
  it { should have_and_belong_to_many :genres }
end