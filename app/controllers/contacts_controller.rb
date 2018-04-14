class ContactsController < ApplicationController
  before_action :load_contactable

  def index
    @contacts = @contactable.contacts
  end

  def new
    @contact = @contactable.contacts.new
  end

  def create
    @contact = @contactable.contacts.new(allowed_params)  
    if @contact.save
      redirect_to [@contactable, :contacts], notice: 'contact created'
    else
      render :new
    end
  end

  private

    def load_commentable
      resource, id = request.path.split('/')[1,2]
      @contactable = resource.singularize.classify.constantize.find(id)
    end
end
