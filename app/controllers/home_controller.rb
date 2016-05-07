class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    keywords = get_key_words
    
    if (keywords.empty?) then
      query = "user_id in (?) OR user_id = ?"
      # @tweets = Tweet.where("user_id in (?) OR user_id = ?", current_user.friend_ids, current_user).paginate(page: params[:page]).order('created_at DESC')  
    else
      query = "(user_id in (?) OR user_id = ?) AND (1=0"
      keywords.each do |keyword|
        query += " OR (tweet_text LIKE " + ActiveRecord::Base.sanitize("%" + keyword + "%") + ")"
      end
      query += ")"
    end
    
    users = User.where("id in (?) OR id = ?", current_user.friend_ids, current_user)
    
    @tag_list = {}
    
    users.each do |u|
      puts "tag: "  + u.tag_statistic.to_s
      statistic = u.tag_statistic.to_s.length == 0 ? [] : JSON::parse(u.tag_statistic)
      tag_hash = parse_to_hash(statistic)  
      merge_tag_list(@tag_list, tag_hash)
      puts @tag_list
    end
    
    
    
    @tweets = Tweet.where(query, current_user.friend_ids, current_user).paginate(page: params[:page]).order('created_at DESC')
  end
  
  private
  def get_key_words
    result = []
    if (!params[:search_words].nil?) then
      result = params[:search_words].split(" ")
      
      # strip the keywords
      result.length.times do |n|
        result[n] = result[n].strip
      end
      
    end
    
    return result
  end
  
  def parse_to_hash(data)
    result = {}
    
    data.each do |item|
      result[item["name"].to_s] = item["count"].to_i
    end
    
    return result
  end
  
  def merge_tag_list(list1, list2)
    puts list1
    puts list2
    list2.each do |k, v|
      if (list1.has_key?(k)) then
        list1[k] += list2[k]
      else 
        list1[k] = list2[k]
      end
    end  
    list1 = list1.sort_by {|_key, value| value}
  end
  
end
