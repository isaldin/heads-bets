require 'spec_helper'

describe AuthController do

  it 'should correct parse oauth callback' do
    get :do_it, format: '&access_token=4f16cb17cbb346d78be98d11f5c13b180dd06e697a2fdbc0151098aa5da849fe9a05751745e0af60f44c5&expires_in=86400&user_id=12914467'
    controller.params[:format].should == '&access_token=4f16cb17cbb346d78be98d11f5c13b180dd06e697a2fdbc0151098aa5da849fe9a05751745e0af60f44c5&expires_in=86400&user_id=12914467'

    controller.parse_token(controller.params[:format]).should == {
        :access_token => '4f16cb17cbb346d78be98d11f5c13b180dd06e697a2fdbc0151098aa5da849fe9a05751745e0af60f44c5',
        :expires_in => '86400',
        :user_id => '12914467'
    }
  end

end