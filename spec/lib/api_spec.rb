require_relative '../spec_helper'

describe Varese::API do
  specify { Varese::API.wont_be_nil }
  specify { Varese::AccessToken.wont_be_nil }
  

end

