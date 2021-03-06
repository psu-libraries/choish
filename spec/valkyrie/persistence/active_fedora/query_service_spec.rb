# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::ActiveFedora::QueryService do
  let(:adapter) { Valkyrie::Persistence::ActiveFedora::MetadataAdapter.new }
  let(:persister) { adapter.persister }
  let(:query_service) { adapter.query_service }

  it_behaves_like 'a Valkyrie query provider'

  describe 'find_members' do
    context 'when they come from solr' do
      it 'can find properties and member_ids of sub-resources' do
        pending 'This passes individually but not when run in the suite'
        nested_child = persister.save(resource: Collection.new)
        middle_child = persister.save(resource: Collection.new(member_ids: nested_child.id, title: 'Test', read_groups: ['public'], read_users: ['tpend']))
        parent = persister.save(resource: Collection.new(member_ids: middle_child.id))

        child = query_service.find_members(resource: parent).first

        expect(child.member_ids).to eq [nested_child.id]
        expect(child.title).to eq ['Test']
        expect(child.read_groups).to eq ['public']
        expect(child.read_users).to eq ['tpend']
      end
    end
  end
end
