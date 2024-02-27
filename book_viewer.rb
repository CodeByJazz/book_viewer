require "tilt/erubis"
require "sinatra" 
require "sinatra/reloader"

before do 
  @chapters = File.readlines("data/toc.txt")
end

helpers do 
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |paragraph, index|
      "<p id=paragraph#{index}>#{paragraph}</p>"
    end.join
  end

  def bold_search_terms(paragraph, term)
    paragraph.gsub(term, "<strong>#{term}</strong>")
  end
end

not_found do 
  redirect "/"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].split("=").last
  redirect "/" unless ("1"..@chapters.size.to_s).include?(number)

  @title = "Chapter #{number}: #{@chapters[number.to_i - 1]}"
  
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do 
  @search_terms = params[:query] 
  get_results if @search_terms
  erb :search
end

def get_results 
  @results = []
  @chapters.each_with_index do |chapter, idx|
    text = File.read("data/chp#{idx + 1}.txt")
    @results << [chapter, idx, text] if text.include?(@search_terms)
  end
end

=begin
-Get a list of chapters that contain the search terms 
-Get a list of all the paragraphs in the chapter that contain the search terms
[["kklnafnlnfw", "nlwfkalk"] ["kdlaksdlkand,"]]
=end

