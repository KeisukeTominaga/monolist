class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
      #binding.pry
    else
      @item = Item.find(params[:item_id])
    end

    if @item.new_record?
      begin

        response = Amazon::Ecs.item_lookup(params[:asin] , 
                                    :response_group => 'Medium' , 
                                    :country => 'jp')        

      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!

    else
      @item = Item.find(params[:item_id])
    end
    
    if params[:type] == "Want"
      current_user.want(@item)
    elsif params[:type] == "Have"
      current_user.have(@item)
    end

  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == "Want"
      current_user.unwant(@item)
    elsif params[:type] == "Have"
      current_user.unhave(@item)
    end
    
  end
end
