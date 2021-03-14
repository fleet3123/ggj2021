extends Node


onready var bg_music = $BackgroundMusic
onready var sfx = $SFX

# Wann startet ein Kampf?
# Monster beginnt Angriff -> Monster findet Spieler
# Monster wird getroffen -> beginnt Spielersuche

# Wann endet ein Kampf?
# Wenn die Lister der Encounter abgearbeitet ist.
# Called when the node enters the scene tree for the first time.

func _ready():
    pass # Replace with function body.
    
func _on_encounter_started ( _idx ):
    var enemies = get_tree().get_nodes_in_group ( "mob" )
    for enemy in enemies:
        enemy.connect ( "first_hit", self, "_on_fight_started" )

func _on_fight_started():
    bg_music.audio_state = bg_music.BATTLE
    
    
func _on_fight_ended():
    bg_music.audio_state = bg_music.NORMAL
    
    
