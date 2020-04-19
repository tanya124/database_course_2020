import requests
import json
from time import strftime
from time import gmtime
import sys
from random import randrange


data_albums = ''
data_artists = ''
data_tracks = ''
data_album_x_track = ''
data_album_x_artist = ''
data_artist_x_track = ''
data_track_x_user = ''
data_track_x_playlist = ''
tracks_array = []

def duration_convert(duration):
	return strftime("%H:%M:%S", gmtime(duration))


def generate_data_albums(id, title, year):
	global data_albums
	data_albums += '{0};{1};{2};description\n'.format(str(id), title, year)

def generate_data_artist(id, name):
	global data_artists
	data_artists += '{0};{1};{2};{3};{4}\n'.format(str(id), name, name, name, '0')

def generate_data_tracks(id, gener, title, duration):
	global data_tracks
	data_tracks += '{0};path;{1};{2};{3};comment\n'.format(str(id), gener, title, duration)

def generate_data_album_x_track(id_album, id_track):
	global data_album_x_track
	data_album_x_track += '{0};{1}\n'.format(str(id_album), str(id_track))

def generate_data_album_x_artist(id_artist, id_album):
	global data_album_x_artist
	data_album_x_artist += '{0};{1}\n'.format(str(id_artist), str(id_album))

def generate_data_artist_x_track (id_track, id_artist):
	global data_artist_x_track
	data_artist_x_track += '{0};{1}\n'.format(str(id_track), str(id_artist))

def generate_data_track_x_user(track_id, user_id, amount, like, added):
	global data_track_x_user
	data_track_x_user += '{0};{1};{2};{3};{4};\n'.format(str(user_id), str(track_id), str(amount), str(like), str(added))

def generate_data_track_x_playlist(track_id, playlist_id):
	global data_track_x_playlist
	data_track_x_playlist += '{0};{1}\n'.format(str(playlist_id), str(track_id))

current_album_id = 100001
for i in range(100):
	current_album_id += i
	URL = 'https://deezerdevs-deezer.p.rapidapi.com/album/{}'.format(str(current_album_id))

	response = requests.get(
		URL,
		headers={'RapidAPI Project' : 'default-application_4369649',
			'x-rapidapi-host': 'deezerdevs-deezer.p.rapidapi.com',
			'x-rapidapi-key': '1f2f0ed425mshbe0d70e47871224p13d5a9jsne777ba2f3fb4'},
		)

	data = json.loads(response.content)
	try:
		title = data['title']
		date = data['release_date']
		artist = data['artist']
		artist_id = artist['id']
		artist_name = artist["name"]
		tracks = data['tracks']['data']
		gener = data['genres']['data'][0]['name']

		generate_data_albums(current_album_id, title, date)
		generate_data_artist(artist_id, artist_name)
		generate_data_album_x_artist(artist_id, current_album_id)

		for track in tracks:
			track_id = track['id']
			tracks_array.append(track_id)
			track_title = track['title']
			track_duration = duration_convert(track['duration'])
			generate_data_tracks(track_id, gener, track_title, track_duration)
			generate_data_album_x_track(current_album_id, track_id)
			generate_data_artist_x_track(track_id, artist_id)
	except:
		pass

for track in tracks_array:
	user_id = randrange(100)
	playlist_id = 99 - user_id
	added = randrange(2)
	generate_data_track_x_user(track, user_id, randrange(20), randrange(2), added)
	if added == 1:
		generate_data_track_x_playlist(track, playlist_id)

with open('artists.csv', 'w') as f:
	f.write(data_artists)

with open('albums.csv', 'w') as f:
	f.write(data_albums)

with open('tracks.csv', 'w') as f:
	f.write(data_tracks)

with open('album_x_track.csv', 'w') as f:
	f.write(data_album_x_track)

with open('artist_x_album.csv', 'w') as f:
	f.write(data_album_x_artist)

with open('artist_x_track.csv', 'w') as f:
	f.write(data_artist_x_track)

with open('user_x_track.csv', 'w') as f:
	f.write(data_track_x_user)

with open('data_track_x_playlist.csv', 'w') as f:
	f.write(data_track_x_playlist)



