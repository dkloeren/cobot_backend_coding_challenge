# frozen_string_literal: true

# this service will post a single membership's attributes to the Cobot api
class ImportService
  ACCESS_TOKEN = 'token-hard-coded-for-the-challenge-only'
  SUBDOMAIN = 'test-space'

  def run(membership_attributes)
    post_import_to_cobot(membership_attributes)
  end

  private

  def post_import_to_cobot(attributes)
    cobot_client.post(
      SUBDOMAIN, '/membership_import',
      membership: attributes
    )
  rescue CobotClient::TooManyRequests => e
    sleep e.response.headers[:retry_after].to_i
    retry
  rescue RestClient::Exception => e
    nil
  end

  def cobot_client
    CobotClient::ApiClient.new(ACCESS_TOKEN)
  end
end
