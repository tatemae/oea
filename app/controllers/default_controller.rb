class DefaultController < ApplicationController

  def index
    @comparing_fractions = Assessment.find_by_title("Comparing Fractions")
  end

  def contact
    @page_title = 'Contact Us'
    if request.post?
      body = []
      params.each_pair do |k,v|
        if !['authenticity_token', 'action', 'controller'].include?(k)
          body << "#{k}: #{v}"
        end
      end
      errors = []
      errors << "your name" if params[:name].blank? unless params[:contact_form_type] == 'simple'
      errors << "your email" if params[:email].blank?
      errors << "a subject" if params[:subject].blank?
      errors << "a message" if params[:message].blank?

      if errors.blank?
        UserMailer.contact_email(params[:email], params[:name]).deliver
        flash[:notice] = 'Thanks for contacting us!'
        redirect_to contact_url
        return
      else
        if errors.length > 1
          errors.unshift("Please provide")
          flash[:error] = errors.to_sentence
        else
          flash[:error] =  "Please provide " + errors.join(' ')
        end
      end
    end
    respond_to do |format|
      format.html { render }
    end
  end

  def take
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end
