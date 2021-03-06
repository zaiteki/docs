require "spec_helper"

require_relative "../app"
require_relative "../lib/site_index"

describe Contents do
  before :all do
    @site_index = SiteIndex.new(site_name: 'frontend')
  end

  it "lists all sites in the /sites/ directory" do
    all_sites = Dir['sites/**'].map { |site_path| site_path.sub('sites/', '') }
    @site_index.sites.should =~  all_sites
  end

  it "emboldens the current site, links other sites" do
    index_html = Nokogiri.parse(@site_index.to_html)

    current_site = index_html.css("li.current").first.text
    current_site.should == 'frontend'

    other_sites = index_html.css('a').map(&:text)
    other_sites.should =~ (@site_index.sites - ['frontend'])
  end
end
