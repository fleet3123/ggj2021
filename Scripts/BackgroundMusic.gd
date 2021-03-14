extends AudioStreamPlayer

enum {
    NORMAL,
    AMBIENT,
    BATTLE
}

export (AudioStream) var battle
export (AudioStream) var ambient
export (AudioStream) var normal

var audio_state = NORMAL setget set_audio_state, get_audio_state
var switched : bool = false

func _ready():
    switch_audio()

func _process ( _delta ):

    if switched:
        switch_audio()


func get_audio_state():
    return audio_state

func set_audio_state ( state ):

    if state != audio_state:
        audio_state = state
        switched = true

func switch_audio ():

    switched = false
    stop()
    match audio_state:
        NORMAL:
            self.stream = normal
        AMBIENT:
            self.stream = ambient
        BATTLE:
            self.stream = battle
    play()


func _on_finished():
    match audio_state:
        NORMAL:
            self.audio_state = AMBIENT
        AMBIENT:
            continue
        BATTLE:
            switch_audio()
