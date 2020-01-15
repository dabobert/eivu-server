module Types
  class MutationType < Types::BaseObject
    field :generate_token_via_otp, mutation: Mutations::GenerateTokenViaOtp



    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end

  end
end
