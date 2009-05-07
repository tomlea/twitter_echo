Factory.define(:echo) do |e|
  e.auth_details({:secret => "foo", :token => "bar"})
  e.sequence(:username){|i| "user_#{i}"}
end
