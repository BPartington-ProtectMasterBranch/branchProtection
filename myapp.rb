require 'sinatra'
require 'json'
require 'net/http'
require 'uri'



post '/payload' do
  username = "bpartington"
  pwd = "#K#9Mh10e2"



  webhook = JSON.parse(request.body.read)
  puts "I got some JSON: #{webhook.inspect}"
  if webhook["ref_type"] == "branch" && webhook["ref"] == "master"
    repo_uri = webhook["repository"]["url"]
    repo_name = webhook["repository"]["name"]
    owner_username = webhook["repository"]["owner"]["login"]

    put_uri = repo_uri + "/branches/master/protection"
    puts "put_uri: " + put_uri

    uri = URI.parse(put_uri)
    request = Net::HTTP::Put.new(uri)
    request.body = '{"required_status_checks":{"strict":true,"contexts":[]},"enforce_admins":true,"required_pull_request_reviews":{"dismissal_restrictions":{"users":["' + owner_username + '"],"teams":[]},"dismiss_stale_reviews":true},"restrictions":{"users":["' + owner_username + '"],"teams":[],"apps":[]},"required_linear_history":true,"allow_force_pushes":true,"allow_deletions":true}'

    request.basic_auth(username, pwd);
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    
    puts "response: " + response.body


    protectionResp = JSON.parse(response.body)
    
    issue_uri = repo_uri + "/issues"
    puts "issue_uri: " + issue_uri

    postIssueUri = URI.parse(issue_uri)
    issueReq = Net::HTTP::Post.new(postIssueUri)

    issueBody = '@' + username + '\nRequired Status Checks:\n\tstrict: ' + protectionResp["required_status_checks"]["strict"].to_s() + '\n\nWill add more protections to this issue in the future'
    
    issueReq.body = '{"title":"' + repo_name + ': Master Branch Protected","body":"' + issueBody + '"}'

    puts "issueReq.body: " + issueReq.body

    issueReq.basic_auth(username, pwd);
    
    issue_req_options = {
      use_ssl: postIssueUri.scheme == "https",
    }
    
    issueResp = Net::HTTP.start(postIssueUri.hostname, postIssueUri.port, issue_req_options) do |http|
      http.request(issueReq)
    end

    puts "issueResp: " + issueResp.body

  end
end
