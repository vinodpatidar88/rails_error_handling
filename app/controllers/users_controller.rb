class UsersController < ApiController
   skip_before_action :authenticate, only: %i[create auth_user]

   def create
      user = User.find_or_initialize_by({ 
        email: params[:email],
        mobile_number: params[:mobile_number]
      })
      generate_token = Random.uuid(15)
      user.login_token.create!(token: generate_token)
      user.name = params[:name]
      render json: { data: user.save }, status: :ok
   end

   def auth_user
     user = User.find(email: params[:email])

     if user.blank?
        self.errors.add(:message, 'User Invalid !') 
        return
     end

     token = user.login_token.create!(token: generate_token)[:token]

     data = {
        token:,
        is_valid: true
     }

     render json: {data: data}, status: :ok
   end

   def index
     rendor json: { data: User.find(current_user&.id) }, status: :ok
   end
end