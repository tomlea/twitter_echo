Factory.define(:echo) do |e|
  e.auth_details({:secret => "foo", :token => "bar"})
end
