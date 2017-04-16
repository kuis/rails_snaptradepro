require 'spec_helper'

describe Attachment do
  describe "associations" do
    it { should belong_to :attachable }
    it { should belong_to :uploader }
  end

  describe "validations" do
    it { should validate_presence_of :uploader }
    it { should validate_presence_of :file_name }
    it { should validate_presence_of :file_size }
    it { should validate_presence_of :file_url }
    it { should validate_presence_of :file_type }
  end
end
