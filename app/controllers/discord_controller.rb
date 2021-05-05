class DiscordController < ApiController
  skip_before_action :set_language, :set_ownership, :verify_authenticity_token

  def interactions
    # Request signature verification
    begin
      verify_request! if Rails.env.production?
    rescue Ed25519::VerifyError
      return head :unauthorized
    end

    body = JSON.parse(request.body.read)

    if body['type'] == 1
      # Respond to Discord PING request
      render json: { type: 1 }
    else
      # Respond to /commands
      type = body['data']['name']

      begin
        if type == 'profile'
          user = body['data']['resolved']['users'].values.first
          profile = { id: user['id'], username: user['username'],
                      avatar: "https://cdn.discordapp.com/avatars/#{user['id']}/#{user['avatar']}" }
          data = Discord.embed_user(profile)
        else
          search = body['data']['options'].first

          if search.has_key?('options')
            # Command with subcommands (e.g. multiple search field options)
            field = search['options'].first['name']
            value = search['options'].first['value']
          else
            # Basic command
            field = search['name']
            value = search['value']
          end

          if type == 'card'
            if field == 'number'
              data = Discord.embed_card(number: value)
            else
              data = Discord.embed_card(name: value)
            end
          elsif type == 'npc'
            data = Discord.embed_npc("name_en_cont=#{value}")
          elsif type == 'pack'
            data = Discord.embed_pack("name_en_cont=#{value}")
          else
            render json: { type: 4, data: { content: 'Sorry, something broke!' } }
          end
        end

        render json: { type: 4, data: data }
      rescue RestClient::ExceptionWithResponse => e
        # Return API error messages when they are provided
        render json: { type: 4, data: { content: JSON.parse(e.response)['error'] } }
      rescue Exception => e
        Rails.logger.error(e.inspect)
        e.backtrace.first(3).each { |line| Rails.logger.error(line) }
        render json: { type: 4, data: { content: 'Sorry, something broke!' } }
      end
    end
  end

  private
  def verify_key
    Ed25519::VerifyKey.new([Rails.application.credentials.dig(:discord, :interactions_public_key)].pack('H*')).freeze
  end

  def verify_request!
    signature = request.headers['X-Signature-Ed25519']
    timestamp = request.headers['X-Signature-Timestamp']
    verify_key.verify([signature].pack('H*'), "#{timestamp}#{request.raw_post}")
  end
end
