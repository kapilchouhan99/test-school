require 'rails_helper'

RSpec.describe Result, type: :model do
  describe 'validations' do
    it 'validates presence of subject' do
      result = Result.new(marks: 80)
      expect(result).not_to be_valid
      expect(result.errors[:subject]).to include("can't be blank")
    end

    it 'validates presence of marks' do
      result = Result.new(subject: 'Math')
      expect(result).not_to be_valid
      expect(result.errors[:marks]).to include("can't be blank")
    end
  end
end
