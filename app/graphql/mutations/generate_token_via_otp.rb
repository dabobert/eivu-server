class Mutations::GenerateTokenViaOtp < GraphQL::Schema::Mutation
  argument :id, ID, required: true
  argument :otp_code, String, required: true

  type Types::UserType

  def resolve(args)
    user = User.find(args[:id])
  end
end