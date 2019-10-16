require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'hello, world が表示されること' do
    get '/'
    expect(response.body).to match(hello)
  end
end