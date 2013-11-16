require 'spec_helper'

describe Resource do
  it { should validate_presence_of(:event) }
  it { should validate_presence_of(:name) }
end
