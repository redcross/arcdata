class Incidents::Api::ResponderMessagesTwilioController < ApplicationController
  skip_before_filter :require_valid_user!
  skip_before_filter :require_active_user!
  before_filter :validate_twilio_incoming
  protect_from_forgery with: :null_session

  def incoming
    p "INCOMING"
    body = params[:Body]
    person = find_person_by_phone params[:From]

    if params[:NumMedia] && (media_count = params[:NumMedia].to_i) > 0
      media_urls = []
      media = media_count.times.map do |i|
        {content_type: params["MediaContentType#{i}"],
         url: params["MediaUrl#{i}"]}
         media_urls << params["MediaUrl#{i}"]
      end
      media_urls = media_urls.join(", ");
      body += " [The message has #{media_count} #{media_count == 1 ? 'attachment' : 'attachments'}. They can be found at #{media_urls}]"
    else
      media = []
    end

    message = Incidents::ResponderMessage.new chapter: chapter, message: body, person: person, local_number: params[:To], remote_number: params[:From], direction: 'incoming'
    message.save!

    unless person
      respond_with_message Incidents::ResponderMessage.new(message: "A person with this phone number was not found in the database.")
      return
    end

    reply = Incidents::ResponderMessageService.new(message, media).reply
    if reply && reply.message.present?
      respond_with_message reply
      reply.save
    else
      head :no_content
    end
  end

  protected

  def respond_with_message reply
    render_message_string reply.message
    reply.direction = 'reply'
    reply.local_number = params[:To]
    reply.remote_number = params[:From]
  end

  def render_message_string message
    twiml = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
    render text: twiml.text
  end

  def find_person_by_phone phone
    phone = phone.gsub /^\+1/, ''
    phone = "#{phone[0..2]}-#{phone[3..5]}-#{phone[6..9]}"
    Roster::Person.for_chapter(chapter).with_phone_number(phone).first
  end

  def chapter
    p "CHAPTER"
    @chapter ||= Roster::Chapter.with_twilio_account_sid_value(params[:AccountSid])
                                .with_incidents_twilio_number_value(params[:To]).first!
  end

  def validate_twilio_incoming
    @validator = Twilio::Util::RequestValidator.new chapter.twilio_auth_token
    if !@validator.validate(request.original_url, request.POST, request.env['HTTP_X_TWILIO_SIGNATURE'])
      render status: 403, text: 'Invalid Signature'
    end
  end

  def user_for_paper_trail
    "DCSOps SMS"
  end
end