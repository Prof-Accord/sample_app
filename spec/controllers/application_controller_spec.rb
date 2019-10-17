require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  
  it 'hello, world が表示されること' do
    get :hello
    expect(response.status).to eq(200)
  end
  
end