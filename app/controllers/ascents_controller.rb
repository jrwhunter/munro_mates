class AscentsController < ApplicationController

  include SessionsHelper

  before_action :signed_in_user

  # IMPORT
  def import
      CSV.foreach(params[:file].path, headers: true) do |row|
    		Ascent.new(
          { user_id: current_user.id, 
            hill_id: Hill.find_by(number: row.field('number')).id,
            date: row.field('date')!=nil ? Date.strptime(row.field('date'), '%d/%m/%y') : nil, 
            notes: row.field('notes'),
            climbed: true }
          ).save
  		end

      hills = Hill.where(category: params[:category])
      logger.warn "Hills #{hills}"
      hills.each do |hill|
        if Ascent.find_by(user_id: current_user.id, hill_id: hill.id) == nil
          Ascent.new(
          { user_id: current_user.id, 
            hill_id: hill.id,
            date: nil, 
            notes: '',
            climbed: false }
            ).save
        end
      end
    redirect_to root_url, notice: "Ascents imported."
  end

  # DESTROY ALL
  def destroy_all
    Ascent.where(user_id: current_user).destroy_all
    redirect_to root_url, notice: "Ascents deleted."
  end

  def get_edit
    @hill_ids = params[:hill_ids] != nil ? params[:hill_ids] : []
    if @hill_ids.length() == 1 
      @ascent = Hill.find(@hill_ids.first()).ascents.find_by(user_id: current_user)
    else
      @ascent = nil
    end
    #respond_to do |format|
      #format.html { render "hills/index" }
      #format.js
    #end
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
    if success
      respond_to do |format|
        format.html { render "hills/index" }
        format.js
      end
    else
      flash.now[:danger] = 'Problem with updating ascent'   
    end
  end


end
