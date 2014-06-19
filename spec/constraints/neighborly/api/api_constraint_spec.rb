require 'spec_helper'

describe Neighborly::Api::ApiConstraint do
  let(:request) { double :request }

  describe '#matches?' do
    let(:version) { 1 }

    def header_for_version(version)
      "version=#{version}"
    end

    context 'when default is false' do
      subject(:constraint) { described_class.new(version: version) }


      it 'matches requests including the versioned vendor mime type' do
        headers = { accept: header_for_version(version) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end

      it 'does not match requests for other versions' do
        headers = { accept: header_for_version(version + 1) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq false
      end
    end

    context 'when default is true' do
      subject(:constraint) { described_class.new(version: version, default: true) }

      it 'matches requests including the versioned vendor mime type' do
        headers = { accept: header_for_version(version) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end

      it 'matches requests when default is true' do
        headers = { accept: header_for_version(version + 1) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end
    end
  end
end
