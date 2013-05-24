require 'spec_helper'

describe Genre do
  it { should have_and_belong_to_many :sequels }
end