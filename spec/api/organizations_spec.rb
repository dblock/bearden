require 'rails_helper'

describe 'GET /organizations' do
  include Api::Test

  context 'with no term' do
    it 'returns a 400 with an error message' do
      expect do
        client.organizations._resource
      end.to raise_error Faraday::Error::ClientError do |e|
        expect(e.response[:status]).to eq 400
        expect(e.response[:body]).to eq 'Missing Term'
      end
    end
  end

  context 'with an organization' do
    let(:organization) { Fabricate :organization }
    let!(:organization_name) { Fabricate(:organization_name, organization: organization, content: 'David Zwirner Gallery') }
    before do
      Organization.recreate_index!
      organization.es_index
      Organization.refresh_index!
    end
    context 'with a valid term' do
      it 'returns the matches for that term' do
        existing_organizations = client.organizations(term: 'David')
        expect(existing_organizations.count).to eq 1
        existing_organization = existing_organizations.first
        expect(existing_organization.names).to eq organization.names
        expect(existing_organization.tag_names).to eq organization.tag_names
        expect(existing_organization.website_urls).to eq organization.website_urls
        expect(existing_organization.cities).to eq organization.cities
        expect(existing_organization.countries).to eq organization.countries
        expect(existing_organization.in_business).to eq organization.in_business
      end
    end
    context 'with an id' do
      it 'returns the organization' do
        existing_organization = client.organization(id: organization.id)
        expect(existing_organization.names).to eq organization.names
        expect(existing_organization.tag_names).to eq organization.tag_names
        expect(existing_organization.website_urls).to eq organization.website_urls
        expect(existing_organization.cities).to eq organization.cities
        expect(existing_organization.countries).to eq organization.countries
        expect(existing_organization.in_business).to eq organization.in_business
      end
    end
  end

  context 'with more than DEFAULT_SEARCH_SIZE organizations' do
    let(:default_size) { Api::OrganizationsController::DEFAULT_SEARCH_SIZE }
    before do
      Organization.recreate_index!
      (default_size + 1).times do
        organization = Fabricate :organization
        Fabricate :organization_name, organization: organization
        organization.es_index
      end
      Organization.refresh_index!
    end
    it 'returns no more results than the DEFAULT_SEARCH_SIZE' do
      expect(client.organizations(term: 'Gallery').count).to eq default_size
    end
    it 'respects the size sent from the client' do
      expect(client.organizations(term: 'Gallery', size: 2).count).to eq 2
    end
  end
end
