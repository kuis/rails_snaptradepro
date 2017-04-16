def parsed_body
  @parsed_body ||= ActiveSupport::JSON.decode(response.body)
end

def parsed_response
  @parsed_response ||= parsed_body["response"]
end

def click_first_submit(text)
  first("input[value='#{text}']").click
end

def click_first_link(text)
  first("a", text: text).click
end
