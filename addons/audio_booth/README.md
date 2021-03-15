# Audio Booth 

A Simple Adaptive Music & SFX Helper for Godot 3.1
This plugin comes with nodes that will help you set up your adaptive music and organize sound effects in Godot 3.1.
---

# Music

## `Song` Node

The `Song` node represents a single song with all it's instruments.

It has the following properties:

- `tempo`
	- the speed of the song in beats per minute.
- `beats`
	- how many beats a bar has.

You **must** fill out these properties.

The `Song` itself does not hold any audio stream to play, it will only hold containers, which then will hold `AudioStreamPlayer`s as their children.
There are two types of Containers.

## `TrackContainer` Node

A `Song` needs to have *exacly* one `TrackContainer` which itself needs to have *at least* one `AudioStreamPlayer` as its child. The first child of the TrackContainer will be the *core* of the song. If you play a song, it will only play its core.

However, you can add more `AudioStreamPlayer`s to the `TrackContainer` and play them *in addition* to the core at will, by calling the corresponding functions of the MusicBooth.
All `AudioStreamPlayer`s in the `TrackContainer` are considered tracks. 

## `StingerContainer` Node

Additionally to the `TrackContainer`, you can add any number of `StingerContainer`s to the Song. Each `StingerContainer` can have any number `AudioStreamPlayer`s.
The `StingerContainer` allows you to randomly play sound effects - here called stingers - synced to your song.

The `StingetContainer` has the following properties:

- `tick_type`
	- defines whether the counter shall be connected to the `beat` or `bar` signal of the song
- `wait_ticks`
	- defines on which beats / bars a stinger might be played.
	- if set to `4`, this means that every 4 beats / bars, there is the given probability to play *one* stinger of *this* `StingerContainer`
- `probability`
	- the probability that a stinger will be played on the beat / bar

## `MusicBooth` Node

With the `MusicBooth` you control your songs, define when to play which song or when to add/remove certain tracks/instruments from the current song. 

It provides the following functions:

- `play_song(song_name: String, fade_time : float = 0.0) -> void`
	- `song_name` the name of the `Song` node that shall be played. Only plays the first track.
	- `fade_time` defines how long the fade in shall durate.
	- will *immediately* play a specific track of the current song.
	- if another song is already playing, it will stop it and all it's tracks before playing the new song.

- `play_song_on_beat(song_name: String, fade_time: float = 0.0, delay: int = 0)`
	- `song_name` the name of the `Song` node that shall be played. Only plays the first track.
	- `fade_time` defines how long the fade in shall durate.
	- `delay` defines how many *beats* later the song shall be played.
	- if another song is already playing, it will stop it and all it's tracks before playing the new song.

- `play_song_on_bar(song_name: String, fade_time: float = 0.0, delay: int = 0)`
	- `song_name` the name of the `Song` node that shall be played. Only plays the first track.
	- `fade_time` defines how long the fade in shall durate.
	- `delay` defines how many *bars* later the song shall be played.
	- if another song is already playing, it will stop it and all it's tracks before playing the new song.

- `play_track(track: int, fade_time: float = 0.0) -> void`
	- `track` defines the track which shall be played.
	- `fade_time` defines how long the fade in shall durate.
	- will *immediately* play a specific track of the current song.

- `play_track_on_beat(track: int, fade_time: float = 0.0, delay: int = 0)` 
	- `track` defines the track which shall be played.
	- `fade_time` defines how long the fade in shall durate.
	- `delay` defines how many *beats* later the track shall be played.
	- will play a specific track of the current song *on the next beat* when no delay is defined.

- `play_track_on_bar(track: int, fade_time: float = 0.0, delay: int = 0)` 
	- `track` defines the track which shall be played.
	- `fade_time` defines how long the fade in shall durate.
	- `delay` defines how many *bars* later the track shall be played.
	- will play a specific track of the current song on the next *bar* when no delay is defined.

- `stop_song(fade_time : float = 0.0) -> void`
	- `fade_time` defines how long the fade out shall durate.
	- stops the current playing song *immediately*.

- `stop_song_on_beat(fade_time: float = 0.0, delay: int = 0)`
	- `fade_time` defines how long the fade out shall durate.
	- `delay` defines how many *beats* later the song shall be stopped.

- `stop_song_on_bar(fade_time: float = 0.0, delay: int = 0)`
	- `fade_time` defines how long the fade out shall durate.
	- `delay` defines how many *bars* later the song shall be stopped.

- `stop_track(track: int, fade_time: float = 0.0) -> void`
	- `track` defines the track which shall be stopped.
	- `fade_time` defines how long the fade out shall durate.
	- will *immediately* stop a specific track of the current song.

- `stop_track_on_beat(track: int, fade_time: float = 0.0, delay: int = 0)` 
	- `track` defines the track which shall be stopped.
	- `fade_time` defines how long the fade out shall durate.
	- `delay` defines how many *beats* later the track shall be stopped.
	- will stop a specific track of the current song *on the next beat* when no delay is defined.

- `stop_track_on_bar(track: int, fade_time: float = 0.0, delay: int = 0)` 
	- `track` defines the track which shall be stopped.
	- `fade_time` defines how long the fade out shall durate.
	- `delay` defines how many *bars* later the track shall be stopped.
	- will stop a specific track of the current song on the next *bar* when no delay is defined.

- `is_playing() -> bool`
	- returns whether the MusicBooth is playing a song or not

- `is_song_playing(song_name: String) -> bool`
	- returns whether `song_name` is the song that is currently played or not.

## General Structure

A scene tree with two songs could look like this:

```
- Root
- - MusicBooth
- - - Song1
- - - - TrackContainer
- - - - - Track0 (Core)
- - - - - Track1
- - - - - Track2
- - - Song2
- - - - TrackContainer
- - - - - Track0 (Core)
- - - - - Track1
- - - - - Track2
- - - - - Track3
- - - - StingerContainer
- - - - - Stinger1
- - - - - Stinger2
- - - - - Stinger3
```

The *Root* node might be your level.
it should have an `onready var music_booth = $MusicBooth` and from there you can call all the fancy functions the `MusicBooth` offers.

The `MusicBooth` itself only holds `Song` nodes as its children.

Each `Song` node should have exactly *one* `TrackContainer` and can have any number of `StingerContainer`s.

If a `Song` is played, it will only play it's *Core*. Other tracks of that song can be layered on top of the core at will.
 
*Song2* also has single StingerContainer. This means, depending on the properties, every some beat or bar one of the stingers will be played at random.
However, this is only true if *Song2* is the current song played by the `MusicBooth`.

# Sound

## `Sound` Node

Sound effects are stored in the `Sound` node. The `Sound` node is similar to an audio player, but has some extended functionallity, like being able to play the sound it holds multiple times simultaneously, randomize pitch / volume or plays variations of your sound at random.

It has the following properties:

- `singleton: bool`
	- when the singleton property is active, then it holds only one AudioStreamPlayer, which means if it is played again before it stopped playing, it will restart.
	- if deactivated, the `Sound` node will spawn new AudioStreamPlayers everytime you play the sound, allowing to play the sound multiple times simultaneously
- `stream: AudioStream`
	- this is the audio stream that is played when the sound is played
- `streams: Array`
	- if one or more streams are inside the `streams` array, instead of playing `stream`, it will pick one stream inside `streams` at random to play. This is useful for variations in e.g. footsteps.
- `volume_db: float`
	-wWorks exacly like volume_db of the AudioStreamPlayer.
- `randomize_volume_db: float`
	- if `randomize_volume_db` is set to something bigger than 0.0, it will randomize the volume each time the sound is played.
	- if `volume_db` was set to -10, and `randomize_volume_db` was set to 2, the randomized volume will be between -8 and -12.
- `pitch_scale: float`
	- works  like the `pitch_scale` property of AudioStreamPlayer
- `randomize_pitch_scale: float`
	- works  like `randomize_volume_db`, just for `pitch_scale`.

to play a sound, it needs to be child of the `SoundBooth`, which we will cover next.

## `SoundBooth` Node

The `SoundBooth` is where you manage your `Sound` nodes and play them. It also is really straight forward, it has only one function.

- `func play_sfx(sfx_name: String) -> void:`
	- `sfx_name` the name of the `Sound` node that shall be played.

The `SoundBooth` automatically looks for all `Sound` nodes that are children to it and stores them.
To play it, simply call `sfx_name()` with the *node name* of the `Sound` you want to play!

It searches for `Sound` nodes recursively, so you can organize them in `Node` nodes if you want.
However it does *not* look for children of `Sound` nodes.

---

## Personal Preference.

I like to create two Scenes with MusicBooth and SoundBooth as root node, call them *Music* and *SFX* and make them Singletons (autoloads).
This way I have a single cental place to organice all my music and sfx, and can call them from any script in the game.