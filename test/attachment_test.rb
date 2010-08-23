require './test/test_helper'

class AttachmentTest < ActiveSupport::TestCase
  
  setup do
    class AttachmentModel < LooseChange::Base
      use_database "test_db"
      attachment :photo
    end

    @model = AttachmentModel.new
  end

  should 'accept an attachment' do
    @model.attach :photo, File.open(File.join(File.dirname(__FILE__), 'resources', 'couchdb.png')), :content_type => 'image/png'
    assert @model.save
    @retrieved = AttachmentModel.find(@model.id)
    assert_equal @retrieved.photo.size, @model.photo.size
  end

end
