class Request
  require 'lib/common'
  include MongoMapper::Document
  include Diaspora::Webhooks
  include ROXML

  xml_accessor :_id
  xml_accessor :person, :as => Person
  xml_accessor :destination_url
  xml_accessor :callback_url

  key :destination_url, String
  key :callback_url, String
  key :person_id, ObjectId

  belongs_to :person
  
  validates_presence_of :destination_url, :callback_url

  scope :for_user, lambda{ |user| where(:destination_url => user.url) }
  scope :from_user, lambda{ |user| where(:destination_url.ne => user.url) }

  def self.instantiate(options ={})
    person = options[:from]
    self.new(:destination_url => options[:to], :callback_url => person.url, :person => person)
  end

  def activate_friend 
    p = Person.where(:url => self.person.url).first
    p.active = true
    p.save
  end

end
