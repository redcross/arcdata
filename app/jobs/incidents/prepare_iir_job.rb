class Incidents::PrepareIirJob

  def self.enqueue *args
    Delayed::Job.enqueue new(*args)
  end

  def initialize iir
    @iir_id = iir.id
  end

  def iir
    @iir ||= Incidents::InitialIncidentReport.find @iir_id
  end

  def perform
    pdf_data = render_pdf
    make_attachment pdf_data
    #distribute_notification pdf_data
  end

  def distribute_notification pdf_data
    Incidents::Notifications::Notification.create_for_event iir.incident, 'initial_incident_report', attachment_filename: filename, attachment_data: pdf_data, extra_recipients: [iir.approved_by, iir.completed_by].compact

    emails = iir.incident.region.iir_emails || ''
    extra_contacts = emails.split(',').select(&:present?)
    extra_contacts.each do |contact|
      Incidents::Notifications::Mailer.initial_incident_report_extra_contact(contact, iir.incident, attachment_filename: filename, attachment_data: pdf_data).deliver
    end
  end

  def render_pdf
    html = view_html
    margin = '.25in'
    kit = PDFKit.new(html, :page_size => 'Letter', margin_bottom: margin, margin_top: margin, margin_left: margin, margin_right: margin)
    kit.to_pdf
  end

  def view_html
    tz = iir.incident.region.time_zone
    html = nil
    Time.use_zone(tz) do
      html = RenderMan.new(file: 'incidents/initial_incident_reports/show', defs: {resource: iir}, layout: 'thin').render 
    end
    
    # Insert correct path to assets
    html.gsub %r{['"](/assets/[^'"]*)['"]} do |match|
      # See if the asset has been precompiled
      path = File.join(Rails.application.root, "public", match[2..-2])
      if !File.exists? path
        # Try to treat this as a sprockets asset and get its compiled filesystem path
        assetname = match[9..-2]
        asset = Rails.application.assets[assetname]
        path = asset.pathname if asset
      end
      "'file://#{path}'"
    end
  end

  class NamedStringIO < StringIO
    attr_accessor :original_filename, :content_type
  end

  def make_attachment data
    io = NamedStringIO.new(data)

    io.content_type = 'application/pdf'
    io.original_filename = filename

    puts "\n\n\n#{iir.incident.id}\n\n\n"
    attachment = iir.incident.attachments.build do |att|
      att.attachment_type = 'iir'
      att.file = io
      att.name = "Initial Incident Report"
    end
    attachment.save!

    #publish_attachment
  end

  def publish_attachment
    Incidents::UpdatePublisher.new(iir.incident).publish_attachments
  end

  def filename
    date_str = iir.incident.date.strftime "%Y%m%d"
    "#{date_str}_#{iir.incident.region.name}_#{iir.incident.humanized_incident_type}_IIR.pdf"
  end

end