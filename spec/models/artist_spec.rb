require 'spec_helper'

describe Artist do

  before :each do
    Artist.destroy_all
  end

  #it 'should create artist if he doesnt exist' do
  #  Artist.count.should == 0
  #  @artist = FactoryGirl.create(:artist)
  #  Artist.count.should == 1
  #end

end
