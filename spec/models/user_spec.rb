require 'spec_helper'

describe User do

  before :each do
    Artist.destroy_all
    User.destroy_all
    Bet.destroy_all
    @user = FactoryGirl.create :user
  end

  it 'should correct do bet' do
    Artist.destroy_all
    @artist = FactoryGirl.build :artist

    @user.bets.count.should == 0
    Artist.count.should == 0
    @user.do_bet @artist
    @user.bets.count.should == 1
    Artist.count.should == 1
  end

  it 'shouldnt do bet if bet to this artist already did' do
    @artist = FactoryGirl.build :artist
    @same_artist = FactoryGirl.build :artist

    @user.bets.count.should == 0
    @user.do_bet @artist
    @user.bets.count.should == 1
    @user.do_bet @same_artist
    @user.bets.count.should == 1
  end

end