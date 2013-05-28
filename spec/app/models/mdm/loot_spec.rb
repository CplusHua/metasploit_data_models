require 'spec_helper'

describe Mdm::Loot do
   context 'associations' do
     it { should belong_to(:workspace).class_name('Mdm::Workspace') }
     it { should belong_to(:service).class_name('Mdm::Service') }
     it { should belong_to(:host).class_name('Mdm::Host') }
   end

   context 'factory' do
     it 'should be valid' do
       loot = FactoryGirl.build(:mdm_loot)
       loot.should be_valid
     end
   end

   context '#destroy' do
     it 'should successfully destroy the object' do
       loot = FactoryGirl.create(:mdm_loot)
       expect {
         loot.destroy
       }.to_not raise_error
       expect {
         loot.reload
       }.to raise_error(ActiveRecord::RecordNotFound)
     end
   end

   context 'scopes' do
     context 'search' do
       it 'should match on ltype' do
         myloot = FactoryGirl.create(:mdm_loot, :ltype => 'find.this.ltype')
         Mdm::Loot.search('find.this.ltype').should include(myloot)
       end

       it 'should match on name' do
         myloot = FactoryGirl.create(:mdm_loot, :name => 'Find This')
         Mdm::Loot.search('Find This').should include(myloot)
       end

       it 'should match on info' do
         myloot = FactoryGirl.create(:mdm_loot, :info => 'Find This')
         Mdm::Loot.search('Find This').should include(myloot)
       end
     end
   end

   context 'callbacks' do
     context 'before_destroy' do
       it 'should call #delete_file' do
         myloot =  FactoryGirl.create(:mdm_loot)
         myloot.should_receive(:delete_file)
         myloot.destroy
       end
     end
   end
end