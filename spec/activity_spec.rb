require_relative '../lib/ostatus/feed.rb'
require_relative '../lib/ostatus/entry.rb'
require_relative '../lib/ostatus/activity.rb'
require_relative '../lib/ostatus/author.rb'

describe OStatus::Activity do
  before(:each) do
    feed = OStatus::Feed.from_url('test/example_feed.atom')
    entry = feed.entries[0]
    @activity = entry.activity
    entry = feed.entries[1]
    @activity_empty = entry.activity
  end

  describe "#object" do
    it "should give an Author containing the content of the activity:object tag" do
      @activity.object.class.should eql(OStatus::Author)
    end

    it "should give nil when no activity:object was given" do
      @activity_empty.object.should eql(nil)
    end
  end

  describe "#object-type" do
    it "should give a String containing the content of the activity:object-type tag" do
      @activity.object_type.should eql(:note)
    end

    it "should give nil when no activity:object-type was given" do
      @activity_empty.object_type.should eql(nil)
    end
  end

  describe "#verb" do
    it "should give a String containing the content of the activity:verb tag" do
      @activity.verb.should eql(:post)
    end

    it "should give nil when no activity:verb was given" do
      @activity_empty.verb.should eql(nil)
    end
  end

  describe "#target" do
    it "should give a String containing the content of the activity:target tag" do
      @activity.target.should eql('Barbaz')
    end

    it "should give nil when no activity:target was given" do
      @activity_empty.target.should eql(nil)
    end
  end
end
