module Types
  class MutationType < Types::BaseObject

    field :generate_token_via_otp, mutation: Mutations::GenerateTokenViaOtp
  end
end
