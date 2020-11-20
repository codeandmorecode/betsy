require "test_helper"

describe User do

  describe "relations" do

    it "has products" do
      user_1 = users(:user_1)
      expect(user_1).must_respond_to :products
      user_1.products.each do |product|
        expect(product).must_be_kind_of Product
      end
      end


  end



end
