
module Jah
  class PostAgent


        def post(url, error, body, headers = Hash.new, &response_handler)
      return unless url
      request(url, response_handler, error) do |connection|
        post = Net::HTTP::Post.new( url.path +
                                    (url.query ? ('?' + url.query) : ''),
                                    HTTP_HEADERS.merge(headers) )
        post.body = body
        connection.request(post)
      end
    end

  end
end
