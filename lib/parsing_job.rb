
class ParsingJob < Struct.new(:query)
  def perform
    @GMAIL_USERNAME = "tkxel13@gmail.com"
    @GMAIL_PASSWORD = "TechnologyXel123"
    @DOC_KEY = ""
    session = GoogleDrive.login(@GMAIL_USERNAME, @GMAIL_PASSWORD)
    spreadsheet = session.spreadsheet_by_key(@DOC_KEY)
    ws = spreadsheet.worksheets[0]
    row = 2
    selector = "//a[starts-with(@href, \"mailto:\")]/@href"
    (0..1000).step(10) do |start|
      puts "Next #{start}"
      doc = Nokogiri::HTML(RestClient.get "http://www.indeed.com/jobs?q=#{query.gsub(" ","+")}&start=#{start}")
      doc.css('span.company span').each do |company|
        begin
          puts company.content.gsub(",","")
          search_query = "https://www.google.com/search?q="+((company.content).gsub(",","")).gsub(" ","+")+"+contact+us"
          puts search_query
          google_pages = RestClient.get search_query
          html = Nokogiri::HTML google_pages
          contact_us_url = html.search("cite").first.inner_text
          contact_us_url = "http://"+contact_us_url if contact_us_url.match("http").nil?
          puts contact_us_url
          contact_us_page = RestClient.get contact_us_url
          phone = contact_us_page.match(/([0-9]( |-)?)?(\(?[0-9]{3}\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4})/) if !contact_us_page.nil?
          puts phone
          contact_us_html = Nokogiri::HTML.parse contact_us_page
          nodes = contact_us_html.xpath selector
          emails = nodes.collect {|n| n.value[7..-1].split("?").first}
          puts emails
          puts "\n"
          ws[row, 1] = company.content
          ws[row, 2] = contact_us_url
          ws[row, 3] = emails.join(', ')
          ws[row, 4] = phone
          row+=1
        rescue
          next
        end
      end
      ws.save()
    end
  end
end