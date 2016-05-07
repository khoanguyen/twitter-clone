class FindFriendsController < ApplicationController

  before_action :authenticate_user!

  def index
    # workaround for the bug of database adapter
    # it translates empty array into NULL, and the result of below query is always empty
    # add current_user.id into the list to make the list not null
    friend_list = current_user.friend_ids + [current_user.id] 
    
    condition = "id not in (?) AND id != ?"
    filter = params[:name_filter].nil? ? "" : params[:name_filter].strip
    if (filter.length > 0) 
      filter = "%#{filter}%"
      condition += " AND name LIKE ?"
    else
      filter = 1 
      condition += " AND 1=?"
    end
      
    
    @users = User.where(condition, friend_list , current_user.id, filter).paginate(page: params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end
end
