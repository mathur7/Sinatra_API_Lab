require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'


# <h1 style="text-align:center;color:#2A2C31">Search the OMDB Database!</h1>
# 	</header>
# 	<body style="background:#71D2BD; text-align:center; color:#2A2C31">

get '/' do
html_str = <<-eos 
<html>
<h1 style = "text-align:center;font-size:50px;font-family:Impact;color:#6BC221">Flixter</h1>
<body style = "text-align:center;font-size:22px;font-family:Verdana;color:#FEAB28;padding:30px;background:#000000">Enter a movie title or IMDB ID: 
<form method="get" action="/results">
<input type ="text" name="movie">
<input type="submit">
</form <a href="http://imgur.com/qHVzmVN"><img src="http://i.imgur.com/qHVzmVN.jpg" title="Hosted by imgur.com" width=450px /></a>>
</body>

</html>
eos
end

get '/results' do
search = params[:movie]
if search == "" || search == nil
		return "Movie not found"
	end
# movies_title_search {}
response = Typhoeus.get("http://www.omdbapi.com/?s=#{search}")
results = JSON.parse(response.body) #{search}))
results.inspect
html_str = 
<<-eos
<html>
<head>
<h1 style = "text-align:center;font-size:50px;font-family:Impact;color:#6BC221">Flixter</h1>
</head>
<body style = "background:#000000;font-family:Verdana">
eos

results["Search"].each do |h|
html_str += "<a href='/poster/#{h["imdbID"]}'><li style = 'text-align:center;color:#FEAB28'>#{h["Title"]} - #{h["Year"]}</li></a><br></br>"
end

html_str += "</body></html>"

end

get '/poster/:imdbID' do
	search = params[:imdbID]
	html_str = "<html><h1 style = 'text-align:center;font-size:40px;font-family:Impact;color:#6BC221'>Flixter</h1><body style = 'background:#000000;text-align:center;margin-top:20px'>"
	response = Typhoeus.get("http://www.omdbapi.com/?i=#{params[:imdbID]}")
	results = JSON.parse(response.body)
	html_str += "<img src='#{results["Poster"]}'/>"
	html_str += "</body></html>"
	return html_str
end

# <a href="url">Link text</a>
# result["Animals"].each do |index|
# 	puts "#{index["name"]} - #{index["age"]} years old."
# end

# TODO: Add another get here for the poster url.  The path for the poster
# should look like this example '/poster/tt2724064'
#<input type="search" name="Movie Search">
# <html>
# <h1>Movie Search!!</h1><p></p><body>Enter a movie title or IMDB ID number here: </body>

# <form method="get" action="/results">


# <input type="text" name="movie">

# <input type="submit">


# </form>

# </html>


