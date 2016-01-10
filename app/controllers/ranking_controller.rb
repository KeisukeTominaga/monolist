class RankingController < ApplicationController
  
  def have
    @ranking_haves = Have.group(:item_id).order('count_item_id desc').limit(10).count(:item_id)
    #@items = Item.find(@ranking_haves).sort_by{|o| @ranking_haves.index(o.id)}
  end

  def want
    @ranking_wants = Want.group(:item_id).order('count_item_id desc').limit(10).count(:item_id)
    
    #@ranking_wants = Want.group(:item_id).limit(10).count(:item_id)
    #@users_id = Want.where(item_id: @ranking_wants[0]).select(users_id)
    
    #@wanted_users = @item.want_users.all
    #@haved_users = @item.have_users.all
    
  end
  
end
