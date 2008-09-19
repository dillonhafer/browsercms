class Connector < ActiveRecord::Base
  belongs_to :page
  
  #Can't use just 'block', because 'block_type' is used by rails
  belongs_to :content_block, :polymorphic => true

  acts_as_list :scope => 'connectors.page_id = #{page_id} and connectors.container = \'#{container}\' and connectors.page_version'
  alias :move_up :move_higher 
  alias :move_down :move_lower 
  
  validates_presence_of :container
  
  named_scope :for_block, lambda {|b| {:conditions => ['connectors.content_block_id = ? and connectors.content_block_type = ?', b.id, b.class.name]}}
  named_scope :for_container, lambda{|container| {:conditions => ['connectors.container = ?', container]} }
  
end