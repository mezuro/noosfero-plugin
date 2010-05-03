When /^I should see "([^\"]+)" link$/ do |link|
  response.should have_selector("a", :content => link)
end

When /^I should not see "([^\"]+)" link$/ do |link|
  response.should_not have_selector("a", :content => link)
end

Then /^I should be exactly on (.+)$/ do |page_name|
  URI.parse(current_url).request_uri.should == path_to(page_name)
end