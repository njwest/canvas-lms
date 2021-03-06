module Factories
  def user_session(user, pseudonym=nil)
    if caller.grep(/onceler\/recorder.*record!/).present?
      raise "don't stub sessions in a `before(:once)` block; do it in a `before(:each)` so the stubbing works for all examples and not just the first one"
    end

    unless pseudonym
      pseudonym = stub('Pseudonym', :record => user, :user_id => user.id, :user => user, :login_count => 1)
      # at least one thing cares about the id of the pseudonym... using the
      # object_id should make it unique (but obviously things will fail if
      # it tries to load it from the db.)
      pseudonym.stubs(:id).returns(pseudonym.object_id)
      pseudonym.stubs(:unique_id).returns('unique_id')
    end

    session = stub('PseudonymSession', :record => pseudonym, :session_credentials => nil)

    PseudonymSession.stubs(:find).returns(session)
  end

  def remove_user_session
    PseudonymSession.unstub(:find)
  end
end
