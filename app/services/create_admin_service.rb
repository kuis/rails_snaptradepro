class CreateAdminService
  def call
    user = User.find_or_create_by!(email: "admin@user.com") do |user|
      user.password = "password"
      user.password_confirmation = "password"
      user.first_name = "Admin"
      user.last_name = "User"
      user.admin = true
      user.save!
    end
  end
end
