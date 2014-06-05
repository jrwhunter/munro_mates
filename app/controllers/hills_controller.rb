require "csv"

class HillsController < ApplicationController

  include SessionsHelper

  # GET /hills
  # GET /hills.json
  
  def index

    if signed_in? && !current_user.admin

      @category = params[:category]
      if @category== nil
        @category = current_user.category
      else
        current_user.update_attribute(:category, @category)
      end
      @selected = params[:selected]
      if @selected == nil
        @selected = current_user.selected
      else
        current_user.update_attribute(:selected, @selected)
      end
logger.warn(@category)
logger.warn(@selected)
      if @selected=='Climbed' 
        if (@category == 'All')
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id, climbed: true)
          @caption = "All hills climbed"
        else
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id, climbed: true).where("hills.category" => @category)
          @caption = "#{@category} climbed"
        end
      elsif @selected=='To do'
        if (@category == 'All')
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id, climbed: false)
          @caption = "All hills to do"
        else
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id, climbed: false).where("hills.category" => @category)       
          @caption = "#{@category} to do"
        end 
      else 
        if (@category == 'All')
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id)
          @caption = "All hills"
        else
          @ascents = Ascent.includes(:hill).where(user_id: current_user.id).where("hills.category" => @category)
          @caption = "All #{@category}"
        end
      end 
    else
      if @category== nil
        @category = 'Munros'
      end
      if @selected == nil
        @selected = 'All'
      end
      if (@category == 'All')
        @hills = Hill.all
        @caption = "All hills"
      else
        @hills = Hill.where(category: @category)
        @caption = "All #{@category}"
      end 
    end
    @hill_ids = []
    if @full_mates == nil
      @full_mates = Hash.new
    end
    if @part_mates == nil
      @part_mates = Hash.new
    end
    @ascent = nil
    @selected_hills = []
    first = true
    respond_to do |format|
      format.html { render "hills/index" }
      format.js
    end

  end

  # GET /hills/new
  def new
    @hill = Hill.new
  end

  # GET /hills/1/edit
  def edit
    @hill = Hill.find(params[:id])
  end

  # GET /hills/1
  # GET /hills/1.json
  def show
    @hill = Hill.find(params[:id])
  end

  # POST /hills
  # POST /hills.json
  def create
    @hill = Hill.new(hill_params)

    respond_to do |format|
      if @hill.save
        format.html { redirect_to @hill, notice: 'Hill was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hill }
      else
        format.html { render action: 'new' }
        format.json { render json: @hill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hills/1
  # PATCH/PUT /hills/1.json
  def update
    @hill = Hill.find(params[:id])
    respond_to do |format|
      if @hill.update(hill_params)
        format.html { redirect_to @hill, notice: 'Hill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE ALL
  def delete_all
  end

  # DELETE /hills/1
  # DELETE /hills/1.json
  def destroy
    Hill.find(params[:id]).destroy
    flash[:success] = "Hill deleted."
    respond_to do |format|
      format.html { redirect_to hills_url }
      format.json { head :no_content }
    end
  end

  # UPLOAD
  def upload
  end

  # IMPORT
  def import
    #Hill.import(params[:file])
    CSV.foreach(params[:file].path, headers: true) do |row|
      hash = row.to_hash
      logger.warn hash
      category = Hill.get_category(hash["number"])
      Hill.create! hash.merge({"category" => category})
      end
    redirect_to root_url, notice: "Hills imported."
  end

  # DESTROY ALL
  def destroy_all
        if params[:category] == 'Munros'
      pat = 'M___'
    elsif params[:category] == 'Munro Tops'
      pat = 'MT___'
    elsif params[:category] == 'Corbetts'
      pat = 'C___'
    elsif params[:category] == 'Grahams'
      pat = 'G___'
    elsif params[:category] == 'All'
      pat = "%"
    end

    Hill.where("number LIKE ?", pat).destroy_all
    redirect_to root_url, notice: "Hills deleted."
  end

  def get_mates
    @full_mates = Hash.new
    @part_mates = Hash.new
    if @selected_hills.length >0 
      users = User.all
      mates = Hash.new
      users.each do |user|
        if !user.admin && user != current_user
          mates.merge!({user => []})
        end
      end 
      all_hills = []
      @selected_hills.each do |hill|
        all_hills.push(hill)
        get_linked_hills(hill).each do |linked_hill|
          if (all_hills.index(linked_hill) == nil)
            all_hills.push(linked_hill)
          end
        end
      end     
      all_hills.each do |hill|
        ascent = hill.ascents.find_by(user_id: current_user)
        if !ascent.climbed          
          users.each do |user|
            logger.warn(user.name)
            if !user.admin && user != current_user
              their_ascent = hill.ascents.find_by(user_id: user.id)
              if (their_ascent != nil && 
                  !their_ascent.climbed  && # not all users may have ascents loaded
                  user.interested_in(hill.category) &&
                  mates[user].index(hill) == nil)
                mates[user].push(hill)
              end
            end
          end
        end
      end

      logger.warn(mates)
      mates.each do |user, hills|
        if !user.admin && user != current_user
          full = true
          @selected_hills.each do |hill|
            if hills.index(hill) == nil
              full = false
            end
          end
          if full 
            @full_mates.merge!({user => hills})
          elsif hills.length > 0
            @part_mates.merge!({user => hills})
          end
        end
      end
    end
   
  end


  def update_sidebar
    @selected_hills = get_selected_hills()

    if (signed_in? && @selected_hills.length > 0)
      if (!current_user.admin)
        get_mates()
        @ascent = @selected_hills[0].ascents.find_by(user_id: current_user)
      elsif (@selected_hills.length == 1) 
        @linked_hills = get_linked_hills(@selected_hills[0])
      end
    end
    respond_to do |format|
      format.html { render "hills/index" }
      format.js
    end
  end

  def create_links
    @selected_hills = get_selected_hills()
    logger.warn(@selected_hills)   
    @selected_hills.each do |hill1|
      if (hill1.local_links == nil)
        hill1.local_links = ""
      end
      hill1_local_array = hill1.local_links.split(";").map { |s| s.to_i }
      ll = ''
      @selected_hills.each do |hill2|

        if (hill1 != hill2)
         ll.concat("#{hill2.id};")
        end
      end
      logger.warn(ll)
      hill1.update(local_links: ll)
    end
    render nothing: true
  end

  def update_links
    selected_hill = get_selected_hills()
logger.warn(selected_hill)
    if (params[:linked_hill_ids] != nil)
      linked_hills = Hill.find(params[:linked_hill_ids])
    else
      linked_hills = []
    end
    logger.warn(linked_hills)   
    ll = ''
    linked_hills.each do |hill|
      ll.concat("#{hill.id};")
    end
    selected_hill.update(local_links: ll)
    render nothing: true
  end
  
  def get_selected_hills
    if params[:hill_ids] != nil
      logger.warn(params[:hill_ids])
      Hill.find(params[:hill_ids])
    else
      []
    end   
  end

  def get_linked_hills(hill)
    if (hill.local_links != nil)
      Hill.find(hill.local_links.split(";").map { |s| s.to_i })
    else
      []
    end
  end


  def update_multiple
    @hills = Hill.find(params[:hill_ids].split(' '))
    logger.warn @hills
    success = true
    @hills.each do |hill|
      ascent = hill.ascents.find_by(user_id: current_user)
      if params[:climbed] == nil
        pars = {climbed: false}
      else
        pars = {climbed: params[:climbed], date: params[:date], notes: params[:notes]}
      end
      logger.warn pars
      if !ascent.update_attributes!(pars)
        success = false
      end
    end
    index()
    #if success
      #respond_to do |format|
        #format.html { render "index" }
        #format.js
      #end
    #else
      #flash.now[:danger] = 'Problem with updating ascent'   
    #end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hill_params
      params.require(:hill).permit(:number, :name, :other_info, :origin, :chapter, 
        :height, :grid_ref, :map, :category)
    end


end
