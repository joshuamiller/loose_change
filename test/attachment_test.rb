require './test/test_helper'

class AttachmentTest < ActiveSupport::TestCase
  
  setup do
    class AttachmentModel < LooseChange::Base
      use_database "test_db"
      property :name
    end

    @model = AttachmentModel.new
  end

  should 'accept an attachment' do
    @model.attach "photo", File.open(File.join(File.dirname(__FILE__), 'resources', 'couchdb.png')), :content_type => 'image/png'
    assert @model.save
    @retrieved = AttachmentModel.find(@model.id)
    assert_equal({"photo" => {:content_type => 'image/png'}}, @retrieved.attachments)
    assert_not_nil @retrieved.attachment("photo")
    assert_equal @retrieved.attachment(:photo).size, @model.attachment(:photo).size
  end
  
  should 'accept an attachment with spaces in its name' do
    @model.attach "first photo", File.open(File.join(File.dirname(__FILE__), 'resources', 'couchdb.png')), :content_type => 'image/png'
    assert @model.save
    @retrieved = AttachmentModel.find(@model.id)
    assert_equal({"first photo" => {:content_type => 'image/png'}}, @retrieved.attachments)
    assert_not_nil @retrieved.attachment("first photo")
    assert_equal @retrieved.attachment("first photo").size, @model.attachment("first photo").size
  end
  
  should "persist attachment between saves" do
    @model.attach "Photo", File.open(File.join(File.dirname(__FILE__), 'resources', 'couchdb.png')), :content_type => 'image/png'
    assert @model.save
    @retrieved = AttachmentModel.find(@model.id)
    assert_not_nil @retrieved.attachment "Photo"
    @retrieved.name = "Photo"
    @retrieved.save
    @retrieved = AttachmentModel.find(@model.id)
    assert_equal({"Photo" => {:content_type => 'image/png'}}, @retrieved.attachments)
    assert_not_nil @retrieved.attachment("Photo")
    assert_equal @retrieved.attachment("Photo").size, @model.attachment("Photo").size
    assert @retrieved.save
  end
  
end
