class TweetsController < ApplicationController

  before_action :authenticate_user!

  def create
    tags = get_tags
    @tweet = Tweet.new(tweet_params) do |tweet|
      tweet.tags = tags.map { |s| "#" + s }.join
      tweet.user = current_user
      tweet.parent_id = params[:parent_id]
    end
    update_statistic(tags)
    
    users = User.where("id in (?) OR id = ?", current_user.friend_ids, current_user)
    
    @tag_list = {}
    
    users.each do |u|
      puts "tag: "  + u.tag_statistic.to_s
      statistic = u.tag_statistic.to_s.length == 0 ? [] : JSON::parse(u.tag_statistic)
      tag_hash = parse_to_hash(statistic)  
      merge_tag_list(@tag_list, tag_hash)
      puts @tag_list
    end
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @tweet = Tweet.find(params[:id])
    @tweet.update(tweet_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet_id = params[:id]
    respond_to do |format|
      format.js
    end
  end

  def reply
    @tweet = Tweet.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
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
  
  def tweet_params
    params.require(:tweet).permit(:tweet_text, :location, :media)
  end

  def get_tags 
    result = params[:tag_text].split(" ")
    result.length.times do |n|
      result[n] = result[n].downcase
    end
    result = result.uniq
    return result
  end

  def update_statistic(tags)
    current_statistic = current_user.tag_statistic.to_s.length == 0 ? [] : JSON::parse(current_user.tag_statistic)
    current_statistic.each do |item| 
      if (tags.include?(item["name"])) then
        item["count"] = item["count"] + 1
        tags = tags - [item["name"]]
      end
    end  
    
    tags.each do |t|
      current_statistic << { name: t, count: 1 } 
    end
    current_user.tag_statistic = current_statistic.to_json
    current_user.save!
  end

end
